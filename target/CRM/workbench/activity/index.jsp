<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		
		// 为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtnModal").click(function(){

			// 从后台获取用户信息列表，为所有者下拉框铺值
			$.ajax({
				url : "workbench/activity/getUserList.do",
				type : "get",
				dataType : "json",
				success : function(data){
					var html = "";
					// 遍历每一个n，也就是每一个user对象
					$.each(data,function(i,n){
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})

					$("#create-marketActivityOwner").html(html);
					// 所有者下拉框处理完毕后，展现模态窗口
				}
			})

			// 在js中使用 EL 表达式,一定要套用在字符串中
			var id = "${requestScope.user.id}";  // 取得当前登录用户的id
			$("#create-marketActivityOwner").val(id);

			/*
				 操作模态窗口的方式：
				 	操作模态窗口的jquery对象，调用modal方法，为该方法传递参数
				 			show: 打开模态窗口
				 			hide： 关闭模态窗口

			* */
			$("#createActivityModal").modal("show");
		})


		// 为保存按钮绑定事件,执行添加操作(添加，修改，删除 用post方式)
		$("#saveBtn").click(function (){
			$.ajax({
				url : "workbench/activity/save.do",
				data : {

					"owner" : $.trim($("#create-marketActivityOwner").val()),
					"name" : $.trim($("#create-marketActivityName").val()),
					"startDate" : $.trim($("#create-startTime").val()),
					"endDate" : $.trim($("#create-endTime").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-describe").val())
				},
				type : "post",
				dataType : "json",
				success : function(data){

					if(data.success){
						// 添加成功后
					/*
					    1. 刷新市场活动信息列表(ajax)
					    2. 关闭模态窗口
					    3.清空添加模态窗口中的数据
					* */

					//$("#creat-form").submit();  提交表单
						// $("#creat-form").reset() 没有这个方法
						/*
						*  对于表单的jquery对象，提供了submit()方法用于提交表单
						*  但是jquery对象没有提供reset()方法用于重置表单(但是idea提供了reset()方法)
						*
						*  但是js为我们提供了reset()方法
						* */
					$("#creat-form")[0].reset();

					$("#createActivityModal").modal("hide");

					}else{
						alert("添加失败");
					}
				}
			})
		})

        // 页面加载完毕后，触发一个方法，展示信息列表
		pageList(1,3);

		// 给查询按钮绑定事件触发pageList方法
		$("#searchBtn").click(function(){

			// 点击查询按钮时，应该将搜索框中的信息保存到隐藏域中

			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,3);
		})


		// 为全选的复选框绑定事件，触发全选操作
		$("#qx").click(function(){
			$("input[name=xz]").prop("checked",this.checked);
		})

		// 下面这种做法是不行的，因为动态生成的元素是不能以普通绑定事件的形式来进行操作的
		// $("input[name=xz]").click(function(){
		// 	alert(123);
		// })

		/*
		*   动态生成的元素，我们需要以on方法的形式来触发事件
		*
		* 		语法：
		* 			$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		*
		* 			有效元素： 非动态生成的
		* */

		$("#activityBody").on("click",$("#input[name=xz]"),function(){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		})


		// 为删除按钮绑定事件,执行市场活动删除操作
		$("#deleteBtn").click(function(){

			// 找到复选框中所有选中的复选框的jquery对象
			var $xz = $("input[name=xz]:checked");

			if($xz.length == 0){
				alert("请选择需要删除的记录")
			}else{

				// 提醒用户确定删除吗
				if(confirm("确定删除所选中的记录吗？")){
					// 拼接参数
					var param = "";
					for(var i = 0; i  < $xz.length; i++)
					{
						param += "id="+$($xz[i]).val();

						// 如果不是最后一个元素，需要追加一个&
						if(i < $xz.length-1)
						{
							param += "&";
						}
					}
					alert(param);

					$.ajax({
						url : "workbench/activity/delete.do",
						type : "get",
						data : 	param,
						dataType : "json",
						success : function(data){
							/*
                            *  data
                            *   {"success":true/false}
                            * */
							if(data.success)
							{
								pageList(1,3);
							}else{
								alert("删除失败")
							}
						}
					})
				}


			}
		})

		$("#editBtn").click(function(){
			var $xz = $("input[name=xz]:checked");

			if($xz.length == 0)
			{
				alert("请选择需要修改的记录");
			}else if($xz.length > 1)
			{
				alert("每次只能修改一条记录");
			}

		})
		
	});

	  // 对于所有的关系型数据库, 做前端的分页相关操作的基础组件
	 /*  pageNo: 页码     pageSzie：每页展现的记录数 */

	// pageList方法，向后台发送ajax请求，获得最新的市场活动信息列表
	function pageList(pageNo,pageSize){

	    $("#qx").prop("checked",false); // 每次页面刷新的时候，将全选框的值改为false

		// 查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url : "workbench/activity/pageList.do",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"startDate" : $.trim($("#search-startDate").val()),
				"endDate" : $.trim($("#search-endDate").val())
			},
			type : "post",
			dataType : "json",
			success : function(data){
				// 需要的信息
			/*
			*   1. 市场活动信息列表
			*   2. 给分页插件提供的总记录数
			* */

			var html = "";
			$.each(data.dataList,function(i,n){
				html += '<tr class="active">';
				html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
				html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+n.name+'</a></td>';
				html += '<td>'+n.owner+'</td>';
				html += '<td>'+n.startDate+'</td>';
				html += '<td>'+n.endDate+'</td>';
				html += '</tr>';
			})

			$("#activityBody").html(html);

			// 计算总页数
			var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

			// 数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// 该回调函数是在点击分页组件的时候触发的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

	<%--// 创建4个隐藏域，保存搜索框的信息--%>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="creat-form" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate"/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">

					<%--
					      data-toggle = "modal":  表示要打开一个模态窗口

					      data-target="#createActivityModal":
					      		表示要打开哪个模态窗口,通过#id来找到该窗口

					      以属性值和属性的方式写在button元素中，用来打开模态窗口的问题在于没有办法对按钮的功能做扩充

					      所以未来对于触发模态窗口的操作，一定不要写死在元素当中
					      应该由我们自己写js代码来完成操作
					--%>

				  <button type="button" class="btn btn-primary" id="addBtnModal" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn" ><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
                        </tr>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">

				</div>


			</div>
			
		</div>
		
	</div>
</body>
</html>