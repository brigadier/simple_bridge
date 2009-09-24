% Simple Bridge
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (simple_bridge_request).
-export ([
	make/2, 
	behaviour_info/1
]).

make(Module, RequestData) -> 
	RequestData1 = Module:init(RequestData),
	RequestBridge = simple_bridge_request_wrapper:new(Module, RequestData1, false, [], undefined),
	case simple_bridge_multipart:parse(RequestBridge) of
		{ok, Params, OriginalName, TempFile} ->
			RequestBridge:set_multipart(Params, OriginalName, TempFile);
		_ ->
			RequestBridge
	end.

behaviour_info(callbacks) -> [
	{init, 1},           % Should accept the request value passed by the http server.

	{request_method, 1}, % GET, POST, etc.
	{path, 1},           % The path. (http://server.com/<PATH>?querystring)
	
	{headers, 1},        % Return a proplist of headers, key and value are strings.
	{cookies, 1},        % Return a proplist of cookies, key and value are strings.
	{query_params, 1},   % Return a proplist of query parameters, key and value are strings.
	{post_params, 1},    % Return a proplist of post parameters, key and value are strings.

	{peer_ip, 1}        % The remote IP address
];

behaviour_info(_) -> undefined.





