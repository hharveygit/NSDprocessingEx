% This script renders broadband R-squared values to electrodes on T1 slices and gifti brain rendering
% electrodes must be sorted

try % remove entries after EKG
    electrodes(find(strcmp(electrodes.name, 'EKG'))+1:end, :) = [];
end

% Plot on MRI slices
slicesFromNifti(niiPath, electrodes, [], dataBand.broad.rsq(1:height(electrodes)), [], 0.4);

% Plot on Gifti rendering
xyzs = [electrodes.x, electrodes.y, electrodes.z];

if isa(giiPath, 'cell') % combine both giftis if more than 1 path given
    gii = gifti(giiPath{1});
    gii2 = gifti(giiPath{2});
    gii.faces = [gii.faces; gii2.faces + size(gii.vertices, 1)];
    gii.vertices = [gii.vertices; gii2.vertices];
else
    gii = gifti(giiPath);
end

figure('Position', [200, 200, 600, 400]); ieeg_RenderGifti(gii); alpha 0.3
ieeg_viewLight(viewAng(1), viewAng(2));

%plot3(xyzs(:,1), xyzs(:,2), xyzs(:,3), 'o', 'Color','k', 'MarkerSize',6, 'MarkerFaceColor','w'); % no weight
%text(xyzs(:,1), xyzs(:,2), xyzs(:,3), electrodes.name, 'Color', 'k');
plotCortexWeights(xyzs, dataBand.broad.rsq(1:height(electrodes)), 0.05, 0.4); % weighted