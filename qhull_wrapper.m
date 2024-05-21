function [volume, area] = computeConvexHullVolumeAndArea(vertices)
    % computeConvexHullVolumeAndArea - 使用 Qhull 计算多面体的体积和表面积
    %
    % Syntax:  [volume, area] = computeConvexHullVolumeAndArea(vertices)
    %
    % Inputs:
    %    vertices - n x 3 matrix, 包含多面体的顶点坐标
    %
    % Outputs:
    %    volume - 多面体的体积
    %    area - 多面体的表面积
    %
    % Example: 
    %    vertices = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
    %    [volume, area] = computeConvexHullVolumeAndArea(vertices)
    
    % 写顶点数据到临时文件
    tmpFileName = tempname;
    fileID = fopen(tmpFileName, 'w');
    fprintf(fileID, '%d\n', size(vertices, 2));
    fprintf(fileID, '%.6f %.6f %.6f\n', vertices');
    fclose(fileID);
    
    % 调用 Qhull 计算体积和表面积
    [status, result] = system(['qhull FS < ' tmpFileName]);
    
    % 检查 Qhull 命令是否成功执行
    if status ~= 0
        error('Qhull execution failed: %s', result);
    end
    
    % 解析 Qhull 输出结果
    volume = NaN;
    area = NaN;
    resultLines = strsplit(result, '\n');
    for i = 1:length(resultLines)
        line = resultLines{i};
        if contains(line, 'Volume')
            volume = sscanf(line, 'Volume %f');
        elseif contains(line, 'Surface area')
            area = sscanf(line, 'Surface area %f');
        end
    end
    
    % 删除临时文件
    delete(tmpFileName);
    
    % 检查是否成功解析体积和表面积
    if isnan(volume) || isnan(area)
        error('Failed to parse Qhull output: %s', result);
    end
end
