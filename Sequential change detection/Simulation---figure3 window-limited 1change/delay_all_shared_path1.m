function [hit_smote, delay_smote1, ...
          hit_knock, delay_knock1, ...
          hit_norm, delay_norm1, ...
          hit_cusum, delay_cusum1, ...
          hit_B, delay_B1] = ...
          delay_all_shared_path1(p, N, H, r, window, ...
                                threshold_smote, threshold_knock, threshold_norm, ...
                                threshold_cusum, ...
                                threshold_B, reference_B, bandw_B, S_var_B, NB, ...
                                row, Tmax)

    if nargin < 16
        Tmax = 1000;
    end

    threshold_smote = threshold_smote(:);
    threshold_knock = threshold_knock(:);
    threshold_norm  = threshold_norm(:);
    threshold_cusum = threshold_cusum(:);
    threshold_B     = threshold_B(:);

    ns = length(threshold_smote);
    nk = length(threshold_knock);
    nn = length(threshold_norm);
    nc = length(threshold_cusum);
    nb = length(threshold_B);
    
    use_knock = (p > 2*window + 2);

    mu = zeros(1,p);

    % pre-change correlation
    R0 = eye(p);

    % post-change correlation
    R2 = eye(p);
    for i = 1:row
        for j = 1:row
            if i ~= j
                R2(i,j) = r;
            end
        end
    end

    % ---------- storage ----------
    tau_smote = nan(ns, N);
    tau_knock = nan(nk, N);
    tau_norm  = nan(nn, N);
    tau_cusum = nan(nc, N);
    tau_B     = nan(nb, N);

    % ---------- Monte Carlo ----------
    for rep = 1:N
        rand('state',rep);
        randn('state',rep);
        display(['I[',num2str(p),'/',num2str(rep),'/',num2str(N),']'])
        
        % ---------- reference for correlation-based methods ----------
        ref_x = mvnrnd(mu, R0, H)';
        vecho_matrix1 = compute_corr_vecho(ref_x);

        X_stream = [];
        Cusum = -inf;

        done_smote = false(ns,1);
        done_norm  = false(nn,1);
        done_cusum = false(nc,1);
        done_B     = false(nb,1);
        if use_knock
           done_knock = false(nk,1);
        else
           done_knock = true(nk,1);   % disable knockoff so it will not affect stopping rule
        end
        


        for t = 1:Tmax
            % one new post-change observation shared by ALL methods
            x_new = mvnrnd(mu, R2, 1)';
            X_stream = [X_stream, x_new];

            % =======================
            % 1) CUSUM update
            % =======================
            f1 = density_fun(x_new, mu, R2);
            f0 = density_fun(x_new, mu, R0);
            llr = log(f1 / f0);

            if Cusum > 0
                Cusum = Cusum + llr;
            else
                Cusum = llr;
            end

            for k = 1:nc
                if ~done_cusum(k) && Cusum >= threshold_cusum(k)
                    tau_cusum(k, rep) = t;
                    done_cusum(k) = true;
                end
            end

            % =======================
            % 2) your window-limited methods
            % =======================
            Tcur = size(X_stream, 2);
            if Tcur >= 2
                if Tcur < window
                    x0 = X_stream;
                else
                    x0 = X_stream(:, end-window+1:end);
                end

                S_norm_t  = compute_stat_norm(x0, vecho_matrix1, H);
                S_smote_t = compute_stat_smote(x0, vecho_matrix1, H);
                if use_knock
                    S_knock_t = compute_stat_knock(x0, vecho_matrix1, H);
                end
                
                for k = 1:ns
                    if ~done_smote(k) && S_smote_t > threshold_smote(k)
                        tau_smote(k, rep) = t;
                        done_smote(k) = true;
                    end
                end
                
              if use_knock
                for k = 1:nk
                    if ~done_knock(k) && S_knock_t > threshold_knock(k)
                        tau_knock(k, rep) = t;
                        done_knock(k) = true;
                    end
                end
              end

                for k = 1:nn
                    if ~done_norm(k) && S_norm_t > threshold_norm(k)
                        tau_norm(k, rep) = t;
                        done_norm(k) = true;
                    end
                end
            end

             % =======================
             % 3) Scan B-statistic
             % fixed block size = window
             % start from t = 1 by padding with pre-change ref_x
             % =======================
             Y_block = build_padded_block(ref_x, X_stream, window);
             S_B_t = compute_stat_B(reference_B, Y_block, bandw_B, S_var_B, window, NB);

             for k = 1:nb
                  if ~done_B(k) && S_B_t > threshold_B(k)
                       tau_B(k, rep) = t;
                       done_B(k) = true;
                  end
             end

             
            % stop if all thresholds of all methods are hit
            if all(done_smote) && all(done_knock) && all(done_norm) ...
                    && all(done_cusum) && all(done_B)
                break;
            end
        end
    end

    % ---------- summarize ----------
    hit_smote = mean(~isnan(tau_smote), 2);
    hit_norm  = mean(~isnan(tau_norm), 2);
    hit_cusum = mean(~isnan(tau_cusum), 2);
    hit_B     = mean(~isnan(tau_B), 2);
    if use_knock
        hit_knock = mean(~isnan(tau_knock), 2);
        delay_knock1 = mean_ignore_nan_rows(tau_knock);
    else
        hit_knock = nan(nk,1);
        delay_knock1 = nan(nk,1);
        tau_knock = nan(nk,N);
    end

    delay_smote1 = mean_ignore_nan_rows(tau_smote);
  
    delay_norm1  = mean_ignore_nan_rows(tau_norm);
    delay_cusum1 = mean_ignore_nan_rows(tau_cusum);
    delay_B1     = mean_ignore_nan_rows(tau_B);
end

% ============================================================
% build padded B-stat test block
% fixed block size = M = window
% if current stream length < M, pad the front using pre-change ref_x
% ============================================================
function Y_block = build_padded_block(ref_x, X_stream, M)

    Tcur = size(X_stream, 2);

    if Tcur >= M
        Y_block = X_stream(:, end-M+1:end);
    else
        need = M - Tcur;
        Y_block = [ref_x(:, end-need+1:end), X_stream];
    end
end



% ============================================================
% row-wise mean ignoring NaN
% ============================================================
function out = mean_ignore_nan_rows(A)
    nrow = size(A,1);
    out = nan(nrow,1);
    for i = 1:nrow
        tmp = A(i, ~isnan(A(i,:)));
        if ~isempty(tmp)
            out(i) = mean(tmp);
        end
    end
end


% ============================================================
% Normal L2-square statistic
% ============================================================
function S_norm = compute_stat_norm(x0, vecho_matrix1, H)

    [~, T] = size(x0);

    if T < 2
        S_norm = 0;
        return;
    end

    S_tp = zeros(1, T-1);

    for is = 1:(T-1)
        x = x0(:, is:T);
        seg_len = size(x, 2);

        vecho_matrix2 = compute_corr_vecho(x);

        scale = H * seg_len / (H + seg_len);
        S_tp(is) = scale * norm(vecho_matrix1 - vecho_matrix2, 2)^2;
    end

    S_norm = max(S_tp);
end


% ============================================================
% SMOTE-enhanced statistic
% ============================================================
function S_smote = compute_stat_smote(x0, vecho_matrix1, H)

    [p, T] = size(x0);

    if T < 2
        S_smote = 0;
        return;
    end

    x_smote0 = x0;
    Ts0 = size(x_smote0, 2);
    x_smote1 = zeros(p, Ts0);

    for j1 = 1:Ts0
        distance = zeros(1, Ts0);
        for jj = 1:Ts0
            distance(jj) = norm(x_smote0(:,j1) - x_smote0(:,jj));
        end

        [~, b] = sort(distance);
        if length(b) >= 6
            nearest5 = b(1:6);
            nearest5 = setdiff(nearest5, j1);
        else
            nearest5 = setdiff(b, j1);
        end

        if isempty(nearest5)
            x_smote1(:,j1) = x_smote0(:,j1);
        else
            x_rand = nearest5(randperm(length(nearest5),1));
            u = rand;
            x_smote1(:,j1) = u * x_smote0(:,x_rand) + (1-u) * x_smote0(:,j1);
        end
    end

    x_smote = [x_smote0, x_smote1];
    T_aug = size(x_smote, 2);
    S_tp = zeros(1, T-1);

    for is = 1:(T-1)
        x = x_smote(:, is:T_aug);
        seg_len = T - is + 1;

        vecho_matrix2 = compute_corr_vecho(x);

        scale = H * seg_len / (H + seg_len);
        S_tp(is) = scale * norm(vecho_matrix1 - vecho_matrix2, 2)^2;
    end

    S_smote = max(S_tp);
end


% ============================================================
% Knockoff-enhanced statistic
% ============================================================
function S_knock = compute_stat_knock(x0, vecho_matrix1, H)

    [~, T] = size(x0);

    if T < 2
        S_knock = 0;
        return;
    end

    x_knock0 = x0;
    x_knock1 = fixed_equi(x_knock0);
    x_knock  = [x_knock0, x_knock1];
    T_aug = size(x_knock, 2);

    S_tp = zeros(1, T-1);

    for is = 1:(T-1)
        x = x_knock(:, is:T_aug);
        seg_len = T - is + 1;

        vecho_matrix2 = compute_corr_vecho(x);

        scale = H * seg_len / (H + seg_len);
        S_tp(is) = scale * norm(vecho_matrix1 - vecho_matrix2, 2)^2;
    end

    S_knock = max(S_tp);
end


% ============================================================
% Scan B-statistic
% reference_B must remain pure pre-change reference data
% fixed block size = M = window
% ============================================================
function S_B = compute_stat_B(reference_B, Y_block, bandw_B, S_var_B, M, NB)

    % sample NB disjoint reference blocks of size M from reference pool
    % if reference_B is too short, sample without replacement may fail
    L = size(reference_B, 2);
    if L < NB*M
        error('reference_B is too short: need at least NB*M reference samples.');
    end

    idx = randperm(L, NB*M);
    X_sample = reference_B(:, idx);

    % Kyy for common test block
    Kyy = fKxx1_B(Y_block, Y_block, M, bandw_B, 1);
    temp1 = sum(Kyy(:)) / (M*(M-1));

    MMD = zeros(1, NB);

    for j = 1:NB
        Xj = X_sample(:, (j-1)*M+1 : j*M);

        Kxx = fKxx1_B(Xj, Xj, M, bandw_B, 1);
        Kxy = fKxx1_B(Xj, Y_block, M, bandw_B, 2);

        MMD(j) = sum(Kxx(:))/(M*(M-1)) + temp1 - 2*sum(Kxy(:))/(M*(M-1));
    end

    S_B = mean(MMD) / sqrt(S_var_B);
end


% ============================================================
% sample correlation -> vecho
% ============================================================
function vecho_matrix = compute_corr_vecho(x)

    [p, T] = size(x);

    x_mean = mean(x, 2);
    x_sd   = std(x, 0, 2);
    x_sd(x_sd < 1e-8) = 1e-8;

    x_dot = zeros(p, T);
    for i = 1:p
        x_dot(i,:) = (x(i,:) - x_mean(i)) / x_sd(i);
    end

    vecho_matrix = 0;
    for i = 1:T
        vecho_matrix = vecho_matrix + vecho(x_dot(:,i) * x_dot(:,i)');
    end
    vecho_matrix = vecho_matrix / T;
end


% ============================================================
% kernel matrix helper for B-statistic
% copied in spirit from the original online code
% ============================================================
function K = fKxx1_B(A, B, M, bandw, flag)

    switch flag
        case 1
            D = zeros(M, M);
            for i = 1:M
                temp = bsxfun(@minus, A(:, (i+1):M), B(:, i));
                D(i, (i+1):M) = sum(temp.^2, 1);
            end
            D = D + D';
            K = exp(-D / (2*bandw));
            K(logical(eye(size(K)))) = 0;

        case 2
            D = zeros(M, M);
            for i = 1:M
                temp = bsxfun(@minus, A(:,1:M), B(:,i));
                D(1:M, i) = sum(temp.^2, 1);
            end
            K = exp(-D / (2*bandw));
            K(logical(eye(size(K)))) = 0;
    end
end