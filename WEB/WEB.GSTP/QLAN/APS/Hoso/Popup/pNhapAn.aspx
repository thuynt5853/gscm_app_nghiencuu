<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNhapAn.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Hoso.Popup.pNhapAn" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nhập án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <style>
            body {
                width: 98%;
                margin-left: 1%;
                min-width: 0px;
                overflow: auto;
            }
            .boxchung {
                margin: 5px 0;
                width: 100%;
                display: inline-block;
                position: relative;
                float: left;
            }
            .boxchung_body{
                border: 1px solid #c5c5c5;
                border-radius: 5px 5px 5px 5px;
                padding: 10px 1%;
                float: left;
                width: 98%;
                margin-top: 10px;
                padding-top: 20px;
                z-index: 2;
                float: left;
            }
            .tleboxchung {
                position: absolute;
                margin-left: 15px;
                background: #ffe869;
                z-index: 2;
                padding: 0 2px;
                white-space: nowrap;
                border: solid 1px #dcdcdc;
                padding: 5px 10px;
                border-radius: 10px;
                font-weight: bold;
                text-transform: uppercase;
            }
        </style>

        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin vụ việc gốc</h4>
                        <div class="boxchung_body">
                            <asp:DataGrid ID="dgVuAnGoc" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                            Thông tin vụ việc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />

                                            <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                            <br />
                                            <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                            <%#Eval("TruongHopGiaoNhan")%>
                                            <%# Eval("TENTOASOTHAM")%>
                                            <%#Eval("BANAN_QD_ST")%>
                                            <%#Eval("HoTenBiCan")%>
                                            <%#Eval("KHANGNGHI_ST")%>
                                            <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                        HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="65px">
                                        <HeaderTemplate>
                                            Người tạo
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOITAO")%>
                                            <br />
                                            <%#Eval("NGAYTAO")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Mã vụ việc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("MAVUVIEC")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </div>
                    </div>
                    <table class="table1">
                        <tr>
                            <td colspan="2">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên việc</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtTenViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại hình doanh nghiệp</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlLoaiHinhDoanhNghiep" CssClass="chosen-select" runat="server" Width="246px"></asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã việc</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtMaViec" CssClass="user" runat="server" Width="242px"></asp:TextBox>
	                                                    </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Đương sự/ Người tham gia tố tụng</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtDuongSu_NguoiThamGiaToTung" CssClass="user" runat="server" Width="240px"></asp:TextBox>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top:7px;">Cấp xét xử</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlCapXetXu" CssClass="chosen-select" runat="server" Width="246px" AutoPostBack="true" OnSelectedIndexChanged="ddlCapXetXu_SelectedIndexChanged"></asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Toà xét xử</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlToaAnXetXu" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlToaAnXetXu_SelectedIndexChanged"></asp:DropDownList>
	                                                    </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px" margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng thụ lý</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlTinhTrangThuLy" CssClass="chosen-select" runat="server" Width="248px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
			                                                    <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtTuNgayThuly" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgayThuly" Format="dd/MM/yyyy" Enabled="true" />
		                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgayThuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgayThuly" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                                    </div>
	                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
	                                                    <div style="float: left;">
	                                                    <asp:TextBox ID="txtDenNgayThuLy" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
		                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgayThuLy" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                                    </div>
	                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Số thụ lý</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
	                                                    </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlTinhTrangGQ" CssClass="chosen-select" runat="server" Width="248px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="+ Chưa giải quyết xong"></asp:ListItem>
			                                                    <asp:ListItem Value="2" Text="....Chưa phân công Thẩm phán"></asp:ListItem>
			                                                    <asp:ListItem Value="3" Text="....Đã phân công Thẩm phán"></asp:ListItem>
			                                                    <asp:ListItem Value="4" Text="....Đã lên lịch họp"></asp:ListItem>
			                                                    <asp:ListItem Value="5" Text="....Đang hoãn"></asp:ListItem>
			                                                    <asp:ListItem Value="6" Text="....Đang tạm đình chỉ"></asp:ListItem>
			                                                    <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
			                                                    <asp:ListItem Value="8" Text="....QĐ không mở thủ tục phá sản"></asp:ListItem>
			                                                    <asp:ListItem Value="9" Text="....QĐ tuyên bố phá sản"></asp:ListItem>
			                                                    <asp:ListItem Value="10" Text="....QĐ đình chỉ tiến hành thủ tục phá sản"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtTuNgayTinhTrangGQ" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtTuNgayTinhTrangGQ" Format="dd/MM/yyyy" Enabled="true" />
		                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTuNgayTinhTrangGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgayTinhTrangGQ" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                                    </div>
	                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtDenNgayTinhTrangGQ" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtDenNgayTinhTrangGQ" Format="dd/MM/yyyy" Enabled="true" />
		                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtDenNgayTinhTrangGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgayTinhTrangGQ" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                                    </div>
	                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thẩm phán</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
	                                                    </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thời hạn GQ</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlThoiHanGQ" CssClass="chosen-select" runat="server" Width="248px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="Đã hết thời hạn"></asp:ListItem>
			                                                    <asp:ListItem Value="2" Text="Còn thời hạn dưới 10 ngày"></asp:ListItem>
			                                                    <asp:ListItem Value="3" Text="Còn thời hạn dưới 20 ngày"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số QĐ</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
	                                                    </div>
	                                                    <div style="float: left; width: 90px; text-align: center;">Ngày QĐ</div>
	                                                    <div style="float: left;">
		                                                    <asp:TextBox ID="txtNgayQD" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
		                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                                    </div>
	                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thư ký</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlThuKy" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
	                                                    </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Kết quả GQ đơn</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlGQDon" CssClass="chosen-select" runat="server" Width="246px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="5" Text="Thụ lý"></asp:ListItem>
			                                                    <asp:ListItem Value="4" Text="Yêu cầu bổ sung đơn"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="Chuyển đơn cho Tòa án khác"></asp:ListItem>
			                                                    <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
			                                                    <asp:ListItem Value="6" Text="Đơn chưa giải quyết"></asp:ListItem>
			                                                    <asp:ListItem Value="7" Text="Đơn quá hạn chưa giải quyết"></asp:ListItem>
			                                                    <asp:ListItem Value="8" Text="Đơn chưa phân công TP giải quyết"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ủy thác thư pháp</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlUyThacTuPhap" CssClass="chosen-select" runat="server" Width="246px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="Không có ủy thác đi"></asp:ListItem>
			                                                    <asp:ListItem Value="2" Text="Có ủy thác đi"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
	                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">PT rút kinh nghiệm</div>
	                                                    <div style="float: left;">
		                                                    <asp:DropDownList ID="ddlPTRutKinhNghiem" CssClass="chosen-select" runat="server" Width="250px">
			                                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
			                                                    <asp:ListItem Value="2" Text="Không"></asp:ListItem>
		                                                    </asp:DropDownList>
	                                                    </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                <asp:Button ID="cmdNhapan" runat="server" CssClass="buttoninput" Text="Nhập án" OnClick="cmdNhapan_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">

                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                        <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div>
                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%">
                                        <Columns>
                                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>STT</HeaderTemplate>
                                                <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Chọn</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                    <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                                <HeaderTemplate>
                                                    Thông tin vụ việc
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                                    <br />
                                                    <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                                    <%#Eval("TruongHopGiaoNhan")%>
                                                    <%# Eval("TENTOASOTHAM")%>
                                                    <%#Eval("BANAN_QD_ST")%>
                                                    <%#Eval("HoTenBiCan")%>
                                                    <%#Eval("KHANGNGHI_ST")%>
                                                    <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                                HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                                HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="65px">
                                                <HeaderTemplate>
                                                    Người tạo
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("NGUOITAO")%>
                                                    <br />
                                                    <%#Eval("NGAYTAO")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Mã vụ việc
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("MAVUVIEC")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                </div>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                        <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }

            //Khi nhập án thành công
            function OnClose() {
                //Gọi đến function của windown parent
                if (window.opener != null && !window.opener.closed) {
                    window.opener.HideModalDivNhapAn();
                }
                window.close();
            }

            //Khi đóng popup
            $(window).on("beforeunload", function () {
                return window.opener.HideModalDiv();
            })
        </script>
    </form>
</body>
</html>
