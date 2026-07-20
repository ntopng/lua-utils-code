for _, remote in next, game:GetService("ReplicatedStorage"):GetDescendants() do  
    if remote:IsA("RemoteEvent") then  
        game:GetService("RunService") .Heartbeat:Connect(function()  
            for i = 1, 100 do 
                remote:FireServer(math.random(), math.random(), math.random())
            end  
        end)  
    end  
end 
