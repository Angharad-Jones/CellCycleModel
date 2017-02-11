% Class CellOneCDK


classdef CellOneCDK
    properties
        g
        pCDK 
        Size
        CDK = 0
        Threshold_D
        CycleLength = 0
        Phase = 0
        BirthSize 
        DaughterSize1
        DaughterSize2
    end
    
    methods
        function obj = CellOneCDK(g, pCDK, Size, CDK, Threshold_D, CycleLength, Phase, BirthSize, DaughterSize1, DaughterSize2)
            if(nargin > 0)
                obj.g = g;
                obj.pCDK = pCDK;
                obj.Size = Size;
                obj.CDK = CDK;
                obj.Threshold_D = Threshold_D;
                obj.CycleLength = CycleLength;
                obj.Phase = Phase; % 0 = Interphase; 1 = Mitosis; 2 = Divided - exclude from simulation
                obj.BirthSize = BirthSize;
                obj.DaughterSize1 = DaughterSize1;
                obj.DaughterSize2 = DaughterSize2;
            
            end
        end
           
        function tissue = GrowthIteration(tissue, Steps, t, pDependency,tDependency, SizeRecord, LengthRecord, SizeLengthRecord, Ratios, RGRsDaughter1, RGRsDaughter2, pCDK, Threshold_D)
            for j = 1:Steps
                t = t + 1
                n = length(tissue);
                m = 0;
                ActiveCells = [];
                for i = 1:n
                  if tissue(i).Phase < 2;
                     m = m + 1;
                     ActiveCells(m) = i;
                     tissue(i).Size = tissue(i).Size + (tissue(i).Size * (tissue(i).g * 1));  % simulation run at 1 hour time intervals.  To change time interval, *1 should be altered accordingly
                     tissue(i).CDK = tissue(i).CDK + (pCDK * tissue(i).Size * pDependency *1) + (pCDK * (1 - pDependency)*1); % simulation run at 1 hour time intervals.  To change time interval, *1 should be altered accordingly
                     tissue(i).CycleLength = tissue(i).CycleLength + 1;
                     SizeRecord(t, m)= tissue(i).Size;
                     plot(t, tissue(i).Size)
                     if tissue(i).Phase == 0
                        if tissue(i).CDK >= (tissue(i).Threshold_D * (1 - tDependency)) + (tissue(i).Threshold_D * (1/tissue(i).Size) * tDependency)
                           tissue(i).Phase = tissue(i).Phase + 1;
                        else
                        end
                    elseif tissue(i).Phase == 1
                        tissue(i).DaughterSize1 = tissue(i).Size/Ratios(i);
                        tissue(i).DaughterSize2 = tissue(i).Size - tissue(i).DaughterSize1;
                        tissue(i).Phase = tissue(i).Phase + 1;
                        tissue(length(tissue) + 1) = CellOneCDK(RGRsDaughter1(i), pCDK, tissue(i).DaughterSize1, 0, Threshold_D, 0, 0, tissue(i).DaughterSize1, 0, 0); 
                        tissue(length(tissue) + 1) = CellOneCDK(RGRsDaughter2(i), pCDK, tissue(i).DaughterSize2, 0, Threshold_D, 0, 0, tissue(i).DaughterSize2, 0, 0);
                        LengthRecord(i,1) = tissue(i).CycleLength;
                        SizeLengthRecord(i,1) = tissue(i).BirthSize;
                        SizeLengthRecord(i,2) = tissue(i).CycleLength;
                     else
                     end 
                  end  
                end
                ActiveCells;
            while length(ActiveCells) > 100  % This determines the number of cells in the simulation
                shortstraw = randi([1, length(ActiveCells)], 1, 1);
                id = ActiveCells(shortstraw);
                tissue(id).Phase = 2;
                ActiveCells(shortstraw) = [];
            end
            end
       % csvwrite('C:\', SizeRecord)        % to save data on cell size for further analysis enter a valid path here
       % csvwrite('C:\', LengthRecord)      % to save data on cell cycle length for further analysis enter a valid path here
       % csvwrite('C:\', SizeLengthRecord)  % to save data on the correlation of cell size and cell cycle lengthm enter a valid path here
        end
    end
end