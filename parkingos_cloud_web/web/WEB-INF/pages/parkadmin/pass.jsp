<%@ page language="java" contentType="text/html; charset=gb2312"
    pageEncoding="gb2312"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>通道管理</title>
<link href="css/tq.css" rel="stylesheet" type="text/css">
<link href="css/iconbuttons.css" rel="stylesheet" type="text/css">

<script src="js/tq.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.public.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.datatable.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.form.js?0817" type="text/javascript">//表单</script>
<script src="js/tq.searchform.js?0817" type="text/javascript">//查询表单</script>
<script src="js/tq.window.js?0817" type="text/javascript">//弹窗</script>
<script src="js/tq.hash.js?0817" type="text/javascript">//哈希</script>
<script src="js/tq.stab.js?0817" type="text/javascript">//切换</script>
<script src="js/tq.validata.js?0817" type="text/javascript">//验证</script>
<script src="js/My97DatePicker/WdatePicker.js" type="text/javascript">//日期</script>
</head>
<body>
<div id="passobj" style="width:100%;height:100%;margin:0px;"></div>
<script language="javascript">
/*权限*/
var authlist = T.A.sendData("getdata.do?action=getauth&authid=${authid}");
var subauth=[false,false,false,false];
var ownsubauth=authlist.split(",");
for(var i=0;i<ownsubauth.length;i++){
	subauth[ownsubauth[i]]=true;
}
//查看,添加,编辑,删除,道闸
/*权限*/
var comid = ${comid};
function getWorksites (){
	var worksites = eval(T.A.sendData("parkpassedit.do?action=getworksites&comid="+comid));
	return worksites;
}
function getBrake(id){
	var brake = eval(T.A.sendData("parkpassedit.do?action=getbrake&passid="+id));
	return brake;
}
var worksites = getWorksites();
var _mediaField = [
		{fieldcnname:"通道ID",fieldname:"id",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false,edit:false,fhide:true},
		{fieldcnname:"编号",fieldname:"channel_id",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false,edit:false},
		{fieldcnname:"名称",fieldname:"passname",fieldvalue:'',inputtype:"text", twidth:"200" ,height:"",issort:false},
		{fieldcnname:"通道类型",fieldname:"passtype",fieldvalue:'',inputtype:"select",noList:[{"value_no":0,"value_name":"出"},{"value_no":1,"value_name":"入"},{"value_no":2,"value_name":"出入"}], twidth:"100" ,height:"",issort:false},
		{fieldcnname:"所属工作站",fieldname:"worksite_id",fieldvalue:'',inputtype:"select",noList:worksites, twidth:"100" ,height:"",issort:false},
		{fieldcnname:"非月卡车",fieldname:"month_set",fieldvalue:'',defaultValue:'不限制||-1',inputtype:"select", noList:[{"value_no":-1,"value_name":"默认车场设置"},{"value_no":0,"value_name":"不限制"},{"value_no":1,"value_name":"禁止进入"}] , twidth:"100" ,height:"",issort:false},
		{fieldcnname:"月卡第二辆车",fieldname:"month2_set",fieldvalue:'',defaultValue:'不限制||-1',inputtype:"select", noList:[{"value_no":-1,"value_name":"默认车场设置"},{"value_no":0,"value_name":"不限制"},{"value_no":1,"value_name":"禁止进入"}], twidth:"100" ,height:"",issort:false},
		{fieldcnname:"说明",fieldname:"description",fieldvalue:'',inputtype:"text", twidth:"500" ,height:"",issort:false}
	];
var rules =[{name:"passname",requir:true},{name:"worksite_name",requir:true}];
var _passT = new TQTable({
	tabletitle:"通道管理",
	ischeck:false,
	tablename:"pass_tables",
	dataUrl:"parkpassedit.do",
	iscookcol:false,
	//dbuttons:false,
	buttons:getAuthButtons(),
	//searchitem:true,
	param:"action=passquery&comid="+comid,
	tableObj:T("#passobj"),
	fit:[true,true,true],
	tableitems:_mediaField,
	isoperate:getAuthIsoperateButtons()
});
function getAuthButtons(){
	if(subauth[1])
	return [{dname:"添加通道",icon:"edit_add.png",onpress:function(Obj){
		T.each(_passT.tc.tableitems,function(o,j){
			o.fieldvalue ="";
		});
		Twin({Id:"pass_add",Title:"添加通道",Width:550,sysfun:function(tObj){
				Tform({
					formname: "pass_edit_f",
					formObj:tObj,
					recordid:"id",
					suburl:"parkpassedit.do?action=create&comid="+comid,
					method:"POST",
					formAttr:[{
						formitems:[{kindname:"",kinditemts:_mediaField}],
						rules:rules
					}],
					buttons : [//工具
						{name: "cancel", dname: "取消", tit:"取消添加",icon:"cancel.gif", onpress:function(){TwinC("pass_add");} }
					],
					Callback:
					function(f,rcd,ret,o){
						if(ret=="1"){
							T.loadTip(1,"添加成功！",2,"");
							TwinC("pass_add");
							_passT.M();
						}else{
							T.loadTip(1,ret,2,o);
						}
					}
				});	
			}
		})
	
	}}
	]
	return false;
}
//查看,添加,编辑,删除,道闸
function getAuthIsoperateButtons(){
	var bts = [];
	if(subauth[2])
	bts.push({name:"编辑",fun:function(id){
		T.each(_passT.tc.tableitems,function(o,j){
			o.fieldvalue = _passT.GD(id)[j]
		});
		Twin({Id:"pass_edit_"+id,Title:"编辑",Width:550,sysfunI:id,sysfun:function(id,tObj){
				Tform({
					formname: "pass_edit_f",
					formObj:tObj,
					recordid:"pass_id",
					suburl:"parkpassedit.do?action=edit&id="+id,
					method:"POST",
					formAttr:[{
						formitems:[{kindname:"",kinditemts:_passT.tc.tableitems}]
					}],
					buttons : [//工具
						{name: "cancel", dname: "取消", tit:"取消编辑",icon:"cancel.gif", onpress:function(){TwinC("pass_edit_"+id);} }
					],
					Callback:
					function(f,rcd,ret,o){
						if(ret=="1"){
							T.loadTip(1,"编辑成功！",2,"");
							TwinC("pass_edit_"+id);
							_passT.M()
						}else{
							T.loadTip(1,ret,2,o)
						}
					}
				});	
			}
		})
	}});
	if(subauth[3])
	bts.push({name:"删除",fun:function(id){
		var id_this = id ;
		Tconfirm({Title:"确认删除吗",Content:"确认删除吗",OKFn:function(){T.A.sendData("parkpassedit.do?action=delete","post","selids="+id_this,
			function deletebackfun(ret){
				if(ret=="1"){
					T.loadTip(1,"删除成功！",2,"");
					_passT.M()
				}else{
					T.loadTip(1,ret,2,"");
				}
			}
		)}})
	}});
	if(subauth[4])
	bts.push({name:"道闸",fun:function(id){
		T.each(_passT.tc.tableitems,function(o,j){
			o.fieldvalue = _passT.GD(id)[j]
		});
		Twin({Id:"pass_brake_"+id,Title:"道闸",Width:550,sysfunI:id,sysfun:function(id,tObj){
				var brake = getBrake(id)[0];
				Tform({
					formname: "pass_brake",
					formObj:tObj,
					recordid:"pass_id",
					suburl:"parkpassedit.do?action=brake&passid="+id,
					method:"POST",
					formAttr:[{
						formitems:[{kindname:"",kinditemts:[
							{fieldcnname:"名称",fieldname:"brake_name",fieldvalue:brake.brake_name,inputtype:"text", twidth:"200" ,height:"",issort:false},
							{fieldcnname:"串口号",fieldname:"serial",fieldvalue:brake.serial,inputtype:"text", twidth:"200" ,height:"",issort:false},
							{fieldcnname:"设备地址",fieldname:"ip",fieldvalue:brake.ip,inputtype:"text", twidth:"200" ,height:"",issort:false}]}]
					}],
					buttons : [//工具
						{name: "cancel", dname: "取消", tit:"取消成功",icon:"cancel.gif", onpress:function(){TwinC("pass_brake_"+id);} }
					],
					Callback:
					function(f,rcd,ret,o){
						if(ret=="1"){
							T.loadTip(1,"操作成功！",2,"");
							TwinC("pass_brake_"+id);
							_passT.M()
						}else{
							T.loadTip(1,ret,2,o)
						}
					}
				});	
			}
		})
	}});
	if(subauth[5])
	bts.push({name:"抬杆",fun:function(id){
		alert(id);
		var channelId =_passT.GD(id,"channel_id");
		var channelName = _passT.GD(id, "passname");
		//var ret = T.A.sendData("parkpassedit.do","POST","action=liftrod&passname="+channelName+"&channel_id="+channelId+"&channel_operate="+0,
		//null,2,"","","正在。。。");
		var ret = T.A.sendData("parkpassedit.do?action=liftrod&passname="+channelName+"&channel_id="+channelId+"&channel_operate="+0);
		if(ret == "1"){
			T.loadTip(1,"发送成功！",2,"");
		}else if(ret == "0"){
			T.loadTip(1,"发送失败，与停车场连接断开!",2,"");
		}
	}});
	if(bts.length <= 0){return false;}
	return bts;
}
_passT.C();
</script>

</body>
</html>

