<%--
  User: xiaolanhe
  Date: 2021/8/9
  Time: 18:16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>

<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script>
        $(function(){

            if(window.top != window){
                window.top.location = window.location;
            }

            // 页面加载完毕后，将用户文本框的内容清空
            $("#loginAct").val("");

            // 页面加载后，让用户文本框自动获得焦点
            $("#loginAct").focus();

            // 为登录按钮绑定事件，执行登陆操作
            $("#submitBtn").click(function(){
                login()
            })

            // 为当前登录按钮绑定敲回车键(码值是13)事件
            // event：该参数可以获得我们按下的是哪个按键
            $(window).keydown(function(event){
                if(event.keyCode == 13){
                    login()
                }
            })
        })

        // 养成把自定义的function写在 $(function(){})的外面
        function login(){
            //alert("执行验证登录操作")

            // 验证帐号密码不能为空
                // 取得帐号和密码值
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());

            if(loginAct == "" || loginPwd == ""){
                $("#msg").html("账号密码不能为空");

                // 如果账号或者密码为空，需要强制终止
                return false;
            }

            // 后台验证登录相关操作
            $.ajax({
                // 注意这里的路径开头没有 /
                url : "settings/user/login.do",
                data : {
                    "loginAct" : loginAct,
                    "loginPwd" : loginPwd
                },
                type : "post",
                dataType : "json",
                success : function(data){


                    // 分析前端需要什么
                    /*
                      data {"success" : true/false, "msg" : 哪错了}
                    */

                    // 如果登录成功
                    if(data.success)
                    {
                        // 跳转到欢迎页
                        window.location.href = "workbench/index.jsp";
                    // 如果登录失败
                    }else{
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>

</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;xiaolanhe</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input id="loginAct" class="form-control" type="text" placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" class="form-control" type="password" placeholder="密码">
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>