var mysql      = require('mysql'); 
var connection =null;
var jsres={"res":false,"info":"ubs"};
var stdin = process.openStdin();
var request=null;
var countnow = 0;
stdin.on('data', function(chunk){
	var  jsonstr =   JSON.parse(chunk); 
	var  actionar = jsonstr.__path.split("/");
	var  action = actionar[actionar.length-1];
	request = jsonstr;
	if(jsonstr.sqlme.sqlmedbk == 1){
		  connection = mysql.createConnection({
		  host     : jsonstr.sqlme.sqlmeip,
		  user     : jsonstr.sqlme.sqlmeusername,
		  port     : jsonstr.sqlme.sqlmeport,
		  password : jsonstr.sqlme.sqlmepasswd,
		  database : jsonstr.sqlme.sqlmebasename
		});
		connection.connect();	 
	}else if(jsonstr.sqlme.sqlmedbk == 0){
		
	}	
 	if(action == "getfinder"){		
		endexit();
		console.log(JSON.stringify(jsres)); 
	}else if(action == "getusersinfo"){ 
		getusersinfo();		
	}else if(action == "getusersdevice"){ 
		getusersdevice();		
	}else if(action == "changeuserdevicemode"){ 
		changeuserdevicemode();		
	}else if(action == "getwplantlist"){ 
		getwplantlist();		
	}else if(action == "rmwplant"){ 
		rmwplant();		
	}else if(action == "wplantadd"){ //wpdevicehistory
		wplantadd();		
	}else if(action == "wpdevicehistory"){ //wpdevicehistory
		wpdevicehistory();		
	}else if(action == "wfilelistrg"){ //wpdevicehistory
		wfilelistrg();		
	}else if(action == "addziuser"){ //wpdevicehistory //listziuser
		addziuser();		
	}else if(action == "listziuser"){ //listzrdevs
		listziuser();		
	}else if(action == "listzrdevs"){ //getusersdevice
		listzrdevs();		
	}else if(action == "listmydevice"){ //getusersdevice
		listmydevice();		
	}else if(action == "changezidevices"){ //getusersdevice
		changezidevices();		
	}else if(action == "changezimask"){ //getusersdevice
		changezimask();		
	}else if(action == "gtoken"){ //getusersdevice
		gtoken();		
	}else if(action == "getswapinfo"){ //getusersdevice
		getswapinfo();		
	}else if(action == "ffffmyinfo"){ //newnickname
		myinfo();		
	}else if(action == "newnickname"){ //newnickname
		newnickname();		
	}else if(action == "newpasswdnick"){ //save_user_yinsixieyi
		newpasswdnick();		
	}else if(action == "newpasswdnick"){ //save_user_yinsixieyi
		newpasswdnick();		
	}else{
		endexit();
	} 
});  
function newpasswdnick(){
	var sqline = "UPDATE  `sbox_users` SET `user_pass` = '@user_pass' WHERE  ( `id` = '@userid' and `token` = '@token' );";
	sqline = sqline.replace("@userid",request.id);
	sqline = sqline.replace("@token",request.token);
	sqline = sqline.replace("@user_pass",request.newpass); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 			
		}else{
			jsres['res']  = true;
			jsres['info']  = error;  
		}					
		console.log( JSON.stringify(jsres) );
		endexit();
	});
}

function newnickname(){
	var sqline = "UPDATE  `sbox_users` SET `nickname` = '@nickname' WHERE  ( `id` = '@userid' and `token` = '@token' );";
	sqline = sqline.replace("@userid",request.id);
	sqline = sqline.replace("@token",request.token);
	sqline = sqline.replace("@nickname",request.nickname); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			
		}else{
			jsres['res']  = true;
			jsres['info']  = error; 
			jsres['nickname'] = request.nickname; 
		}					
		console.log( JSON.stringify(jsres) );
		endexit();
	});
	
}
function myinfo(){
	var sqline = "SELECT * FROM  sbox_users where ( `id` = '@userid' and `token` = '@token' );";
	 
	sqline = sqline.replace("@userid",request.id);
	sqline = sqline.replace("@token",request.token);
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			
		}else{
			jsres['res']  = true;
			jsres['info']  = error; 
			jsres['data'] = results[0]; 
		}					
		console.log( JSON.stringify(jsres) );
		endexit();
	});
}
function getswapinfo(){
	var sqline = "SELECT * FROM  swap_info;"; 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			
		}else{
			jsres['res']  = true;
			jsres['info']  = error; 
			jsres['data'] = results;
		}					
		console.log( JSON.stringify(jsres) );
		endexit();
	});
}
function gtoken(){
	var sqline = "SELECT * FROM  sbox_users where ( `user_name` = '@user_name' and `user_pass` = '@user_pass' );";
	sqline = sqline.replace("@user_name",request.username);
	sqline = sqline.replace("@user_pass",request.passwd);
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			
		}else if(results.length == 1){
			jsres['res']  = true;
			jsres['info']  = error; 
			jsres['data'] = results[0];
		}else{
			jsres['res']  = false;
			jsres['info']  = error;
		}				
		console.log( JSON.stringify(jsres) );
		endexit();
	});
}
function insertStr(source, start, newStr) {
	return source.slice(0, start) + newStr + source.slice(start+1)
}
function changezimask(){
	var  zuserid = request.userid;
	var  zdex = request.zdex;
	var  zcase = request.zcase;
	jsres['zcase'] = zcase ;
	jsres['zdex']  = zdex ;
	var sqline = "SELECT * FROM sbox_users where id = '@zuserid';";
	sqline = sqline.replace("@zuserid",zuserid);
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['res1']  = false;
			jsres['info']  = error; 					
		}else{
			jsres['res']  = true;
			jsres['results']  = results; 	
			if(results.length  == 1){
				var endmask = "";
				jsres['endmask'] = results[0].mask;
				if(zcase == "false"){
					endmask= insertStr(results[0].mask,parseInt(zdex),"0");
				}else{
					endmask= insertStr(results[0].mask,parseInt(zdex),"1");
					
				}				
				sqline  = "UPDATE  `sbox_users` SET `mask` = '@mask' WHERE (`id` = '@zuserid');";
				sqline = sqline.replace("@zuserid",zuserid);				
				sqline = sqline.replace("@mask",endmask);
				jsres['endmask'] = endmask;
				connection.query(sqline,function(error, results, fields){
					if(error != null ){
						jsres['res1']  = false;
						jsres['info']  = error; 
						
					}else{
						jsres['res1']  = true;
						jsres['info']  = error; 
						jsres['endmask'] = endmask;
					}					
					console.log( JSON.stringify(jsres) );
					endexit();
				});
				
			}else{
				jsres['info']  = error; 
				console.log( JSON.stringify(jsres) );
				endexit();
			}
		} 
		console.log( JSON.stringify(jsres) );
		endexit();
	});
	 
	
}
function changezidevices(){	
	//console.log(request);
	if(request.pus_idstr != "null"){		 
			var sqline = "call pus_str( '@idS' , @masterid, @zid );";
			sqline = sqline.replace("@idS"		,request.pus_idstr);
			sqline = sqline.replace("@masterid" ,request.id);
			sqline = sqline.replace("@zid"	  ,request.gid);			
			connection.query(sqline,function(error, results, fields){
				if(error != null ){
					jsres['res']  = false;
					jsres['sqline']  = sqline;
					jsres['info']  = error; 					
					//changezidevices();
				}else{
					jsres['res']  = true;
					jsres['info']  = error; 					
				}
				if(request.dis_idstr != "null" ){
					sqline = "call dis_str('@idS',@zid);";
					sqline = sqline.replace("@idS"		,request.dis_idstr); 
					sqline = sqline.replace("@zid"	  ,request.gid);
					connection.query(sqline,function(error, results, fields){
						if(error != null ){
							jsres['res']  = false;
							jsres['info']  = error; 					
						}else{
							jsres['res']  = true;
							jsres['info']  = error; 
						}
						console.log( JSON.stringify(jsres) );
						endexit();
					});
				}else{
					console.log( JSON.stringify(jsres) );
					endexit();
				} 
			});
		 
	}else if(request.dis_idstr != "null" ){
		jsres['pus_idstr']  = "null";
		var sqline = "call dis_str('@idS',@zid);";
		sqline = sqline.replace("@idS"		,request.dis_idstr); 
		sqline = sqline.replace("@zid"	  ,request.gid);
		//console.log(sqline);	
		connection.query(sqline,function(error, results, fields){
			if(error != null ){
				jsres['res']  = false;
				jsres['info']  = error; 					
			}else{
				jsres['res']  = true;
				jsres['info']  = error; 
			}
			console.log( JSON.stringify(jsres) );
			endexit();
		});
		  
	}else{
		jsres['pus_idstr']  = "null";
		jsres['dis_idstr']  = "null";
		console.log( JSON.stringify(jsres) );
		endexit();
	}
	 
}
function listmydevice(){
	var  sqline = "SELECT * FROM sbox_device_info where (`user_id` = '@user_id');";
	sqline = sqline.replace("@user_id",request.id);  
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		
		jsres['res']=true;
		jsres['results']=results;
		for(var line  in results){
			jsres['results'][line].devname = new Buffer( results[line].device_name , 'base64').toString(); 
		};	
		//jsres['sqline']=sqline;
		console.log( JSON.stringify(jsres) );
		endexit();
	});	
}

function listzrdevs(){
	var  sqline = "SELECT * FROM sbox_device_info where (`user_id` = '@user_id');";
	sqline = sqline.replace("@user_id",request.ziid);  
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']=true;
		jsres['sqline']=sqline;
		jsres['results']=results;
		console.log( JSON.stringify(jsres) );
		endexit();
	});		
}

function listziuser(){
	var  sqline = "select * from `sbox_users` where  `master_id` =  '@master_id'  ;";
	sqline = sqline.replace("@master_id",request.id); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']=true;
		jsres['results']=results;
		console.log( JSON.stringify(jsres) );
		endexit();
	});	
}

function addziuser(){	
	var sqline = "INSERT INTO  `sbox_users` (`user_name`, `user_pass`, `master_id`, `mask`, `beizhu` , `token`, `nickname`) VALUES ('@user_name', '@user_pass', '@master_id', '@mask', '@beizhu' , '@token', '@nickname');";
 	sqline = sqline.replace("@user_name",request.ziusername); 
	sqline = sqline.replace("@user_pass",request.zipasswd); 
	sqline = sqline.replace("@master_id",request.id); 
	sqline = sqline.replace("@mask",request.mask); 
	sqline = sqline.replace("@beizhu",request.beizhu ); 
	sqline = sqline.replace("@token",request.token ); 	
	sqline = sqline.replace("@nickname",request.nickname ); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']=true;
		jsres['results']=results;
		console.log( JSON.stringify(jsres) );
		endexit();
	});
}

function wfilelistrg(){
	var  sqline = "select * from `warregister` where  `userid` =  '@userid' ;";
 	sqline = sqline.replace("@userid",request.id); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']=true;
		jsres['results']=results;
		console.log( JSON.stringify(jsres) );
		endexit();
	});
};
function wpdevicehistory(){
	var  sqline = "SELECT * FROM sbox_device_info where (`user_id` = '@user_id' and `iswarning` = '99');";
 	sqline = sqline.replace("@user_id",request.id); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']  = true;	
		jsres['results']  = results;  
		for(var line  in results){ 
			jsres['results'][line].devname = new Buffer( results[line].device_name , 'base64').toString(); 
		};		
		console.log( JSON.stringify(jsres) ); 
		endexit();
	});
};
function wplantadd(){
	var  sqline = "INSERT INTO  `warningplant` (`snids`,`url`, `name`, `userid`) VALUES ('@snids','@url','@name','@userid')";
	sqline = sqline.replace("@snids",request.snlist); 
	sqline = sqline.replace("@url",request.url); 
	sqline = sqline.replace("@name",request.plantname); 
	sqline = sqline.replace("@userid",request.id); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		
		jsres['res']  = true;  
		console.log( JSON.stringify(jsres) ); 
		endexit();
	});
};
function rmwplant(){
	var  sqline = "DELETE FROM `warningplant` WHERE (`id` = '@id'  and  userid = '@userid') ;";
	sqline = sqline.replace("@userid",request.id); 
	sqline = sqline.replace("@id",request.pltid); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		}
		jsres['res']  = true;  
		console.log( JSON.stringify(jsres) ); 
		endexit();
	});
};
function getwplantlist(){
	var  sqline = " SELECT * FROM  warningplant WHERE (`userid` = '@userid' );";
	sqline = sqline.replace("@userid",request.id); 
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']  = true;
		jsres['results']  = results; 
		 
		for(var line  in results){ 
			var snids = results[line].snids;
			var snidlist = snids.split("|"); 
			jsres['results'][line].sncount = snidlist.length; 
		};
	 
		console.log( JSON.stringify(jsres) ); 
		endexit();
	});
};
function changeuserdevicemode(){
	var  sqline = "UPDATE  `sbox_device_info` SET `iswarning` = '@iswarning' ,`kind` = '@kind' ,`device_type` = '@device_type'  \
		 WHERE (`user_id` = '@userid' and `id` = '@deviceid' );";
 	sqline = sqline.replace("@userid",request.userid);
	sqline = sqline.replace("@iswarning",request.iswarning);
	sqline = sqline.replace("@device_type",request.device_type);
	sqline = sqline.replace("@kind",request.kind);
	sqline = sqline.replace("@deviceid",request.deviceid);
 	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			jsres['res']  = false;
			jsres['info']  = error; 
			console.log( JSON.stringify(jsres) ); 
			endexit();
		} 
		jsres['res']  = true;
		jsres['efrow']  = results.affectedRows;
		console.log( JSON.stringify(jsres) ); 
		endexit();
	});
};
function getusersdevice(){
	var  sqline = 'SELECT * FROM  sbox_device_info where user_id = \'@userid\';';
	sqline = sqline.replace("@userid",request.userid);
	connection.query(sqline,function(error, results, fields){
		if(error != null ){
			endexit();
		} 
		jsres['data'] = results;
		jsres['res'] = true;
		console.log(JSON.stringify(jsres)); 
		endexit();
	});
};
function getusersinfo(){
	connection.query("SELECT * FROM  sbox_users;",function(error, results, fields){
  
		if(error != null ){
			endexit();
		}
		var obary = [];
		for(var line  in results){ 
			var obj = {};
			obj.id = results[line].id;
			obj.user_name  = results[line].user_name;
			obj.master_id  = results[line].master_id;
			obj.ctime  = 	 results[line].ctime;
			obj.nickname  =  results[line].nickname;
			obj.user_level = results[line].user_level;
			obj.user_type  = results[line].user_type;
			obj.status  =	 results[line].status;
			obj.token  = 	 results[line].token;
			obj.qianfei  =   results[line].qianfei;
			obj.cdnpath  =   results[line].cdnpath;			
			obj.jiankong  =  results[line].jiankong;
			obj.mask  = results[line].mask;
			obary.push(obj);
		};
		jsres['data'] = obary;
		jsres['res'] = true;
		console.log(JSON.stringify(jsres)); 
		endexit();
	});
}
function endexit(){
	if(jsonstr.sqlme.sqlmedbk == 1){
		connection.end();
	}	
	process.exit();	
}