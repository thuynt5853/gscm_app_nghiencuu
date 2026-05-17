<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pXuLyDonKK.aspx.cs" Inherits="WEB.GSTP.UserControl.DKK.pXuLyDonKK" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />

    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>

    <script src="../../UI/js/chosen.jquery.js"></script>
    <script src="../../UI/js/init.js"></script>
    <script src="../../UI/js/jquery.enhsplitter.js"></script>
    <title>Phân loại đơn khởi kiện trực tuyến</title>
    <style>
        body {
            width: 100%;
            min-width: 0px;
        }
        .red{
            color:red;
        }
        .content_popup {
            width: 97%;
            margin: 15px 1.5%;
            float: left;
            position: relative;
            height: 720px;
            overflow-y: auto;
        }

        .right_full_width {
            float: left;
            width: 98%;
        }

        .head_title {
            font-weight: bold;
            font-size: 15pt;
            text-transform: uppercase;
            margin-bottom: 10px;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddVuAnID" runat="server" />
                <asp:HiddenField ID="hddLoaiAn" runat="server" />
                <asp:HiddenField ID="hddLoaiQuanHe" runat="server" />
                <asp:HiddenField ID="hddGSTP_MaVuViec" runat="server" />
                <div class="content_popup">
                    <h4 class="tleboxchung">
                        <asp:Literal ID="lttTieuDe" runat="server"></asp:Literal>
                    </h4>

                    <div class="right_full_width head_title">
                       phân loại đơn khởi kiện trực tuyến
                    </div>

                    <!----------------NOI DUNG DON----------------->
                    <div class="right_full_width">
                        <!---------Vu viec---------------->
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung" style="display: none;">
                                <asp:Literal ID="Literal2" runat="server" Text="Thông tin vụ việc"></asp:Literal>
                            </h4>
                            <div class="boder" style="background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%) repeat scroll 0 0;">
                                <table class="table1" style="width: 96%;">
                                    <tr>
                                        <td style="width: 120px;"><b>Tòa án thụ lý:</b></td>
                                        <td style="width: 250px;">
                                            <asp:Literal ID="lttToaAn" runat="server"></asp:Literal></td>

                                        <td style="width: 105px;"><b>Ngày gửi đơn kiện</b> </td>
                                        <td>
                                            <asp:Literal ID="lttNgayGuiDon" runat="server"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><b>Quan hệ pháp luật<span class="batbuoc">(*)</span></b></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropQHPL" Width="450px"
                                                CssClass="chosen-select" runat="server"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropQHPL_SelectedIndexChanged1">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td><b>Quan hệ pháp luật thống kê<span class="batbuoc">(*)</span></b></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropQHPLThongKe" Width="450px" CssClass="chosen-select" runat="server"></asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td><b>Khởi kiện về lĩnh vực</b></td>
                                        <td colspan="3"><asp:Literal ID="lttLinhVuc" runat="server"></asp:Literal>
                                           </td>
                                    </tr>
                                    <tr runat="server" id="trLydoLyhon" visible="false">
                                        <td><b>Số con chưa thành niên</b></td>
                                        <td>
                                            <asp:Label ID="lbSoConChuaThanhNien" runat="server"></asp:Label>
                                        </td>
                                        <td><b>Lý do xin ly hôn:</b></td>
                                        <td>
                                            <asp:Label ID="lblLyDoLyHon" runat="server"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <div style="text-align: center;">
                                                <asp:Literal runat="server" ID="lbthongbao"></asp:Literal><br />
                                                <asp:Button ID="btnTimkiemdon" runat="server" CssClass="buttoninput quaylai"
                                                    Text="Tìm kiếm đơn" OnClick="cmdTimKiemDon_Click" />
                                                <asp:Button ID="cmdXuLy" runat="server" CssClass="buttoninput quaylai"
                                                    Text="Lưu" CommandArgument="LUU" OnClick="cmdXuLy_Click" OnClientClick="return validate();" />
                                                <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput quaylai"
                                                    Text="Đóng" OnClick="cmdBack_Click" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                            <asp:Panel ID="pnDanhsach" runat="server" Visible="false">
        <style type="text/css">
            input[type="checkbox"] {
                margin-right: 0px !important;
            }

            .duyetkcqqh {
                color: red;
            }
        </style>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="truong">
                    <table class="table1">
                        <tr>
                            <td>
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Thông tin đơn</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr >
                                                <td style="width: 105px;">Mã vụ việc</td>
                                                <td>
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="142px"></asp:TextBox></td>
                                                <td >Tên vụ việc</td>
                                                <td colspan="3" >
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="395px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Người khởi kiện</td>
                                                <td>
                                                    <asp:TextBox ID="txtNguoiKhoiKien" CssClass="user" runat="server" Width="142px"></asp:TextBox>
                                                </td>
                                                 
                                                <%--<td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>--%>
                                                <td>CMND/CCCD</td>
                                                <td style="width:142px">
                                                    <asp:TextBox ID="txtCMNDCCCD" CssClass="user" runat="server" Width="142px" MaxLength="250"></asp:TextBox>
                                                </td>

                                                <td style="width: 83px">Năm sinh</td>
                                                <td style="width:142px">
                                                    <asp:TextBox ID="txtNamSinh" CssClass="user" runat="server" Width="142px" MaxLength="250"></asp:TextBox>
                                                </td>


                                            </tr>
                                            <tr>
                                                <td>Người bị kiện</td>
                                                <td>
                                                    <asp:TextBox ID="txtNguoiBiKien" CssClass="user" runat="server" Width="142px" MaxLength="250"></asp:TextBox></td>
                                                <td>Nội dung khởi kiện</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtNoiDungKhoiKien" CssClass="user" runat="server" Width="395px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            
                                        </table>
                                        <table class="table1">
                                            <tr>
                                                <td colspan="2" style="text-align: center;">
                                                    <asp:Button ID="btnTimKiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="btnTimKiem_Click" />
                                                   
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label1" ForeColor="Red"></asp:Label>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <asp:Panel runat="server" ID="phantrang1" class="sotrang"  Visible="false">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </asp:Panel>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" OnItemDataBound="dgList_ItemDataBound" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"  OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAIVUVIEC" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" OnCheckedChanged="chkChon_CheckedChanged" ToolTip='<%#Eval("TENVUVIEC")%>' AutoPostBack="true" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        
                                        <asp:TemplateColumn HeaderStyle-Width="62px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Mã vụ việc</HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MAVUVIEC")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Thông tin vụ việc</HeaderTemplate>
                                             <ItemTemplate>
                                                <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                                <%#Eval("TruongHopGiaoNhan")%>
                                                <%# Eval("TENTOASOTHAM")%>
                                                <%#Eval("BANAN_QD_ST")%>
                                                <%#Eval("HoTenBiCan")%>
                                                <%#Eval("KHANGNGHI_ST")%>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                            HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Nguyên đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="text-align:center">
                                                    <%#Eval("NGUYENDON")%> <br />
                                                    <%#Eval("SOCMND")%> <br />
                                                    <%#Eval("NAMSINH")%>
                                                </div>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Bị đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("BIDON")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtChitiet" runat="server" CausesValidation="false" Text="Chi tiết"
                                                    CommandName="Chitiet" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <asp:Panel runat="server" ID="phantrang2" class="sotrang"   Visible="false">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </asp:Panel>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
    </asp:Panel>

                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal5" runat="server" Text="Nội dung" />
                            </h4>
                            <div class="boder" style="padding: 10px; ">
                                <asp:Panel ID="pnQDHanhChinh" runat="server">
                                    <div style="float: left; width:100%; margin-bottom: 8px;line-height:22px; border-bottom:dotted 1px #dcdcdc;padding-bottom:10px;">
                                        <asp:Literal ID="lttQDHanhChinh" runat="server"></asp:Literal>
                                    </div>
                                </asp:Panel>
                                <div style="float:left; width:100%; margin-bottom:10px;font-weight:bold;">
                                    Yêu cầu tòa án giải quyết những vấn đề
                                </div>
                                <div style="line-height:22px;width:100%;">
                                <asp:Label ID="lblNoidungdon" runat="server"></asp:Label></div>
                            </div>
                        </div>
                        <!------------Nguyen don--------->
                        <asp:Panel ID="pnNguyenDon" runat="server">
                            <div class="boxchung" style="margin-top: 0px;">
                                <h4 class="tleboxchung">
                                    <asp:Literal ID="lstTitleNguyendon" runat="server" Text="Thông tin người khởi kiện"></asp:Literal>
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Literal ID="lttcount_ND" runat="server"></asp:Literal>
                                    <asp:Repeater ID="rptNguyenDon" runat="server">
                                        <HeaderTemplate>
                                            <table class="table2" style="width: 100%" border="1">
                                                <tr class="header">
                                                    <td style="width: 30px;">TT</td>
                                                    <td style="width: 150px;">Người khởi kiện</td>

                                                    <td style="width: 70px;">Năm sinh</td>
                                                    <td style="width: 100px;">Số CMND</td>
                                                    <td style="width: 100px;">Điện thoại/Fax</td>
                                                    <td>Nơi cư trú hiện tại</td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Container.ItemIndex + 1 %>
                                                </td>
                                                <td><%#Eval("TenDuongSu") %></td>
                                                <td><%#Convert.ToInt32(Eval("NamSinh")+"")>0? Eval("NamSinh"):"" %></td>
                                                <td><%#Eval("SoCMND") %> </td>
                                                <td><%#Eval("DienThoai_Fax") %></td>
                                                <td><%#Eval("HoKhauTamTru") %></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </asp:Panel>
                        <!---------Bi don ---------------->
                        <asp:Panel ID="pnBiDon" runat="server">
                            <div class="boxchung" style="margin-top: 0px;">
                                <h4 class="tleboxchung">
                                    <asp:Literal ID="Literal1" runat="server" Text="Thông tin người bị kiện"></asp:Literal>
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Literal ID="lttcount_BD" runat="server"></asp:Literal>
                                    <asp:Repeater ID="rptBiDon" runat="server">
                                        <HeaderTemplate>
                                            <table class="table2" style="width: 100%" border="1">
                                                <tr class="header">
                                                    <td style="width: 30px;">TT</td>
                                                    <td style="width: 150px;">Người bị kiện</td>

                                                    <td style="width: 70px;">Năm sinh</td>
                                                    <td style="width: 100px;">Số CMND</td>
                                                    <td style="width: 100px;">Điện thoại/Fax</td>
                                                    <td>Nơi cư trú hiện tại</td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Container.ItemIndex + 1 %>
                                                </td>
                                                <td><%#Eval("TenDuongSu") %></td>
                                                <td><%#Convert.ToInt32(Eval("NamSinh")+"")>0? Eval("NamSinh"):"" %></td>
                                                <td><%#Eval("SoCMND") %> </td>
                                                <td><%#Eval("DienThoai_Fax") %></td>
                                                <td><%#Eval("HoKhauTamTru") %></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </asp:Panel>
                        <!----------Duong su--------------->
                        <asp:Panel ID="pnDuongSu" runat="server">
                            <div class="boxchung" style="margin-top: 0px;">
                                <h4 class="tleboxchung">
                                    <asp:Literal ID="Literal3" runat="server" Text="Danh sách các đương sự, người tham gia tố tụng khác"></asp:Literal>
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Repeater ID="rptDuongSuKhac" runat="server">
                                        <HeaderTemplate>
                                            <table class="table2" style="width: 100%" border="1">
                                                <tr class="header">
                                                    <td style="width: 30px;">TT</td>
                                                    <td style="width: 150px;">Họ tên</td>
                                                    <td style="width: 60px;">Năm sinh</td>
                                                    <td style="width: 175px;">Tư cách tố tụng</td>
                                                    <td>Địa chỉ</td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Container.ItemIndex + 1 %></td>
                                                <td>
                                                    <div style="text-align: justify; float: left;">
                                                        <%#Eval("TENDUONGSU") %>
                                                    </div>
                                                </td>
                                                <td><%#Convert.ToInt32(Eval("NamSinh")+"")>0? Eval("NamSinh"):"" %></td>
                                                <td><%#Eval("TuCachToTung") %></td>
                                                <td><%#Eval("HoKhauTamTru") %></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </asp:Panel>
                        <!----------tai lieu------------->
                        <asp:Panel ID="pnTaiLieu" runat="server">
                            <asp:Repeater ID="rptFile" runat="server" OnItemCommand="rptFile_ItemCommand">
                                <HeaderTemplate>
                                    <div class="boxchung" style="margin-top: 0px;">
                                        <h4 class="tleboxchung">
                                            <asp:Literal ID="Literal4" runat="server" Text="Tài liệu, chứng cứ kèm theo đơn khởi kiện "></asp:Literal>
                                        </h4>
                                        <div class="boder" style="padding: 10px;">
                                            <table class="table2" style="width: 100%" border="1">
                                                <tr class="header">
                                                    <td style="width: 30px;">TT</td>
                                                    <td>Tên tài liệu</td>
                                                    <td style="width: 70px;">Tải file</td>
                                                </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Container.ItemIndex + 1 %>
                                            <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                                Value=' <%#Eval("ID") %>' />
                                        </td>
                                        <td>
                                            <div style="text-align: justify; float: left;">
                                                <%#Eval("TenTaiLieu") %>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="text-align: center;">
                                                <asp:ImageButton ID="cmdSua" ImageUrl="/UI/img/dowload.png"
                                                    runat="server" ToolTip="Tải file xuống" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                                                    CommandName="dowload"></asp:ImageButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>  </div></div>
                                </FooterTemplate>
                            </asp:Repeater>
                        </asp:Panel>
                        <!----------------------------->
                          <asp:Literal ID="lttThongTinThem" runat="server"></asp:Literal>
                    </div>
                </div>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function validate() {
                        if (document.getElementById('cmdXuLy').value == 'Ghép đơn') {
                            return true;
                        }
                        var dropQHPL = document.getElementById('<%=dropQHPL.ClientID%>');
                        value_change = dropQHPL.options[dropQHPL.selectedIndex].value;
                        if (value_change == "0") {
                            alert('Bạn chưa chọn quan hệ pháp luật cho đơn kiện này. Hãy kiểm tra lại!');
                            dropQHPL.focus();
                            return false;
                        }

                        var dropQHPLThongKe = document.getElementById('<%=dropQHPLThongKe.ClientID%>');
                        value_change = dropQHPLThongKe.options[dropQHPLThongKe.selectedIndex].value;
                        if (value_change == "0") {
                            alert('Bạn chưa chọn quan hệ pháp luật thống kê cho đơn kiện này. Hãy kiểm tra lại!');
                            dropQHPLThongKe.focus();
                            return false;
                        }
                        return true;
                    }
                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDonOnline();
                        };
                    }

                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script>
            function openInNewTab(url) {
                window.open(url, '_blank').focus();
                var a='@ViewBag.a'
            }
        </script>
    </form>
</body>
</html>
