function load_proxy(file)
f = fopen(file,'r');
hostname = fgetl(f);
port = fgetl(f);
fclose(f);

com.mathworks.mlwidgets.html.HTMLPrefs.setUseProxy(true);
com.mathworks.mlwidgets.html.HTMLPrefs.setProxyHost(hostname);
com.mathworks.mlwidgets.html.HTMLPrefs.setProxyPort(port);
fprintf('Setting proxy host: %s\n',hostname);
fprintf('Setting proxy port: %s\n',port);