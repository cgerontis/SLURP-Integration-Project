% Optitrack Matlab / NatNet Polling Sample
%  Requirements:
%   - OptiTrack Motive 2.0 or later
%   - OptiTrack NatNet 3.0 or later
%   - Matlab R2013
% This sample connects to the server and displays rigid body data.
% natnet.p, needs to be located on the Matlab Path.

function NatNetPollingSample
	fprintf( 'NatNet Polling Sample Start\n' )

	% create an instance of the natnet client class
	fprintf( 'Creating natnet class object\n' )
	natnetclient = natnet;

	% connect the client to the server (multicast over local loopback) -
	% modify for your network
	fprintf( 'Connecting to the server\n' )
	natnetclient.HostIP = '192.168.1.116';
	natnetclient.ClientIP = '192.168.1.145';
	natnetclient.ConnectionType = 'Multicast';
	natnetclient.connect;
	if ( natnetclient.IsConnected == 0 )
		fprintf( 'Client failed to connect\n' )
		fprintf( '\tMake sure the host is connected to the network\n' )
		fprintf( '\tand that the host and client IP addresses are correct\n\n' ) 
		return
	end

	% get the asset descriptions for the asset names
	model = natnetclient.getModelDescription;
	if ( model.RigidBodyCount < 1 )
		return
	end

	% Poll for the rigid body data a regular intervals (~1 sec) for 10 sec.
	fprintf( '\nPrinting rigid body frame data approximately every second for 10 seconds...\n\n' )
	for idx = 1 : 10000  
		java.lang.Thread.sleep(20);
		data = natnetclient.getFrame; % method to get current frame
		
		if (isempty(data.RigidBody(1)))
			fprintf( '\tPacket is empty/stale\n' )
			fprintf( '\tMake sure the server is in Live mode or playing in playback\n\n')
			return
		end
		%fprintf( 'Frame:%6d  ' , data.Frame )
		%fprintf( 'Time:%0.2f\n' , data.Timestamp )
        clc;
		for i = 1:model.RigidBodyCount
			fprintf( 'Name:"%s"  ', model.RigidBody( i ).Name )
			fprintf( 'X:%0.1fmm  ', data.RigidBody( i ).x * 1000 )
			fprintf( 'Y:%0.1fmm  ', data.RigidBody( i ).y * 1000 )
			fprintf( 'Z:%0.1fmm\n', data.RigidBody( i ).z * 1000 )			
		end
	end 
	disp('NatNet Polling Sample End' )
end







 