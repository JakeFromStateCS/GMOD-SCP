SCP.Music = {};

if( SERVER ) then
	function SCP.Music:OnLoad()

	end;

	function SCP.Music:PlaySong( client, url )
		SCP:NetMessage( client, "PlaySong", url );
		if( SCP.Debug.Enabled ) then
			SCP.Debug:Print( client:Nick() .. " is now playing song from URL: " .. url );
		end;
	end;
else
	CreateClientConVar( "SCP_Music_Enabled", 1, true, true );
	if( LocalPlayer().Channel ) then
		LocalPlayer().Channel:Stop();
	end;
	
	function SCP.Music:StopSong()
		if( LocalPlayer().Channel ) then
			LocalPlayer().Channel:Stop();
		end;
	end; 

	function SCP.Nets:PlaySong()
		if( GetConVar( "SCP_Music_Enabled" ) ~= 1 ) then
			return;
		end;
		local url = net.ReadString();
		if( url ) then
			local mp3URL = "http://YoutubeInMP3.com/fetch/?api=advanced&format=JSON&video=" .. url;
			http.Fetch( mp3URL, function( body, len, header, code )
				local tab = util.JSONToTable( body );
				if( tab ) then
					SCP.Music:StopSong();
					sound.PlayURL( tab["link"], "mono", function( channel )
					if( IsValid( channel ) ) then
						local volume = 35;
						channel:SetVolume( volume / 100 );
						LocalPlayer().Channel = channel;
					end;
				end );
				end;
			end,
			function()
				
			end );
		end;
	end;
end;

if( SCP.Debug.Enabled ) then
	SCP.Debug:Print( "Music Module Loaded!" );
end;