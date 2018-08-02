local cameraActive = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0


Citizen.CreateThread(function()
    while true do
        for a = 1, #SecurityCamConfig.Locations do
            local ped = GetPlayerPed(PlayerId())
            local pedPos = GetEntityCoords(ped, false)
            local pedHead = GetEntityRotation(ped, 2)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, SecurityCamConfig.Locations[a].camBox.x, SecurityCamConfig.Locations[a].camBox.y, SecurityCamConfig.Locations[a].camBox.z)
            local distance2 = Vdist(pedPos.x, pedPos.y, pedPos.z, SecurityCamConfig.Locations[a].camBox2.x, SecurityCamConfig.Locations[a].camBox2.y, SecurityCamConfig.Locations[a].camBox2.z)
            if SecurityCamConfig.DebugMode then
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.6, tostring("X: " .. pedPos.x))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.4, tostring("Y: " .. pedPos.y))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.2, tostring("Z: " .. pedPos.z))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z, tostring("H: " .. pedHead))
            end
            local pedAllowed = false
            if #SecurityCamConfig.Locations[a].allowedModels >= 1 then
                pedAllowed = IsPedAllowed(ped, SecurityCamConfig.Locations[a].allowedModels)
            else
                pedAllowed = true
            end

            if pedAllowed then
                if distance <= 5.0 then
                    local box_label = SecurityCamConfig.Locations[a].camBox.label
                    local box_x = SecurityCamConfig.Locations[a].camBox.x
                    local box_y = SecurityCamConfig.Locations[a].camBox.y
                    local box_z = SecurityCamConfig.Locations[a].camBox.z                  
                    Draw3DText(box_x, box_y, box_z, tostring("~g~[H]~w~ Enter Spawn Menu "))
                    if IsControlJustPressed(1, 74) and createdCamera == 0 and distance <= 2.0 then
                        local firstCamx = SecurityCamConfig.Locations[a].cameras[1].x
                        local firstCamy = SecurityCamConfig.Locations[a].cameras[1].y
                        local firstCamz = SecurityCamConfig.Locations[a].cameras[1].z
                        local firstCamr = SecurityCamConfig.Locations[a].cameras[1].r
                        SetFocusArea(1312.4416503906, 4054.0463867188, 266.13256835938, 1312.4416503906, 4054.0463867188, 266.13256835938)
                        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
                        SendNUIMessage({
                            type = "enablecam",
                            label = SecurityCamConfig.Locations[a].cameras[1].label,
                            box = SecurityCamConfig.Locations[a].camBox.label
                        })
                        currentCameraIndex = a
                        currentCameraIndexIndex = 1
                    end
                end
                if distance2 <= 5.0 then
                    local box_label2 = SecurityCamConfig.Locations[a].camBox2.label
                    local box2_x = SecurityCamConfig.Locations[a].camBox2.x
                    local box2_y = SecurityCamConfig.Locations[a].camBox2.y
                    local box2_z = SecurityCamConfig.Locations[a].camBox2.z                    
                    Draw3DText(box2_x, box2_y, box2_z, tostring("~g~[H]~w~ Enter Spawn Menu "))
                    if IsControlJustPressed(1, 74) and createdCamera == 0 and distance <= 2.0 then
                        local firstCamx = SecurityCamConfig.Locations[a].cameras[1].x
                        local firstCamy = SecurityCamConfig.Locations[a].cameras[1].y
                        local firstCamz = SecurityCamConfig.Locations[a].cameras[1].z
                        local firstCamr = SecurityCamConfig.Locations[a].cameras[1].r
                        SetFocusArea(1312.4416503906, 4054.0463867188, 266.13256835938, 1312.4416503906, 4054.0463867188, 266.13256835938)
                        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
                        SendNUIMessage({
                            type = "enablecam",
                            label = SecurityCamConfig.Locations[a].cameras[1].label,
                            box = SecurityCamConfig.Locations[a].camBox2.label
                        })
                        currentCameraIndex = a
                        currentCameraIndexIndex = 1
                    end
                end
            end

            if createdCamera ~= 0 then
                local instructions = CreateInstuctionScaleform("instructional_buttons")
                DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
                SetTimecycleModifier("rply_vignette")
                SetTimecycleModifierStrength(0.1)

                if SecurityCamConfig.HideRadar then
                    DisplayRadar(false)
                end

                -- CLOSE CAMERAS
                if IsControlJustPressed(1, 176) then
                    CloseSecurityCamera()
                    SendNUIMessage({
                        type = "disablecam",
                    })
			if SecurityCamConfig.HideRadar then
                    	   DisplayRadar(true)
                	end
                end

                -- GO BACK CAMERA
                if IsControlJustPressed(1, 174) then
                    local newCamIndex

                    if currentCameraIndexIndex == 1 then
                        newCamIndex = #SecurityCamConfig.Locations[currentCameraIndex].cameras
                    else
                        newCamIndex = currentCameraIndexIndex - 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                end

                -- GO FORWARD CAMERA
                if IsControlJustPressed(1, 175) then
                    local newCamIndex
                    
                    if currentCameraIndexIndex == #SecurityCamConfig.Locations[currentCameraIndex].cameras then
                        newCamIndex = 1
                    else
                        newCamIndex = currentCameraIndexIndex + 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    end
end

function IsPedAllowed(ped, pedList)
    for i = 1, #pedList do
		if GetHashKey(pedList[i]) == GetEntityModel(ped) then
			return true
		end
	end
    return false
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    InstructionButton(GetControlInstructionalButton(1, 176, true))
    InstructionButtonMessage("I have read. Continue to spawn")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end
