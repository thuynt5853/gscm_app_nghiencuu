<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pGiaiQuyet.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Sotham.Popup.pGiaiQuyet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Giải quyết Form</title>

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
        <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
        <asp:HiddenField ID="hddFilePath" runat="server" />
        <asp:HiddenField ID="hddURLKS" runat="server" />

        <script src="../../../UI/js/Common.js"></script>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hdfNgayPCTPGQ" Value="" runat="server" />
        <asp:HiddenField ID="hdfHTND" Value="" runat="server" />
        <asp:HiddenField ID="hdfThuKy" Value="" runat="server" />
        <asp:HiddenField ID="hdfKSV" Value="" runat="server" />

        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <asp:HiddenField ID="hddKhangcaoID" runat="server" Value="0" />
        <asp:HiddenField ID="hddThulyid" runat="server" Value="0" />
        <asp:HiddenField ID="hddKetqua" runat="server" Value="0" />
        <asp:HiddenField ID="hddToaanId" runat="server" Value="0" />
        <asp:HiddenField ID="hddToaAnGiaiQuyetId" runat="server" Value="0" />

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box_nd" style="width: 900px;">
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }

                        .check_list_vertical table td {
                            padding-right: 15px;
                        }

                        .boxchung {
                            padding-top: 10px;
                        }

                        .auto-style1 {
                            height: 36px;
                        }

                        .auto-style2 {
                            height: 36px;
                        }

                        .lable_td {
                            width: 120px;
                        }

                        .checkbox {
                            width: 100%;
                        }

                            .checkbox label {
                                margin-left: 5px;
                            }

                        .text_Right_css {
                            text-align: right;
                        }
                    </style>

                    <div class="truong">

                        <div style="height: 20px;"></div>
                        <div>
                            <h4 class="tleboxchung">Thụ lý hồ sơ đề nghị</h4>
                            <div>
                                <table>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 130px;">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                                        <td style="width: 150px; margin-left: 0px;">
                                            <asp:TextBox ID="txtNgaythuly" runat="server" AutoPostBack="true" CssClass="user" Width="150px" MaxLength="10" OnTextChanged="cmdSuggestSoThuly_Click"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 100px;">Số thụ lý<span class="batbuoc">(*)</span></td>
                                        <td style="width: 150px;">
                                            <asp:TextBox ID="txtSothuly" runat="server" CssClass="user" Width="150px" MaxLength="25" onkeypress="return isNumber(event);"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 130px;">Ngày tạo</td>
                                        <td style="width: 150px; margin-left: 0px;">
                                            <asp:TextBox ID="txtNgayTao" runat="server" AutoPostBack="true" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayTao" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayTao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 130px;">Cán bộ thụ lý</td>
                                        <td>
                                            <div style="width: 400px;">
                                                <asp:DropDownList ID="ddlCanboThuly" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="250px"></asp:DropDownList>
                                                <asp:DropDownList ID="ddlOldCanboThuly" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="250px" Enabled="false"></asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Button ID="cmdCapnhatThuly" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhatThuly_Click" />
                                            <asp:Button ID="cmdXoaThuly" runat="server" CssClass="buttoninput" Text="Xoá" OnClick="cmdXoaThuly_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <asp:Label runat="server" ID="lbthongBaoUpdateThuly" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </div>

                        <div style="height: 20px;"></div>
                        <div>
                            <h4 class="tleboxchung">Thông tin người tiến hành tố tụng</h4>
                            <div>
                                <table>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 130px;">Vai trò tham gia tố tụng<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlTucachTGTT_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <%--<td style="width: 100px;"></td>--%>
                                            <td></td>
                                    </tr>
                                    <asp:Panel ID="pnThamphan" runat="server">
                                        <tr>
                                            <td>Tên thẩm phán<span class="batbuoc">(*)</span></td>
                                            <td style="width: 250px;">
                                                <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </td>
                                            
                                            <td style="width: 100px;">Người phân công</td>
                                            <td style="width: 250px; margin-left: 0px;">
                                                <asp:DropDownList ID="ddlNguoiphancong" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <asp:Panel ID="pnHTND" runat="server" Visible="false">
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblHTND" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                            <td>Người phân công</td>
                                            <td >
                                                <asp:DropDownList ID="ddlHTND_NguoiPC" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                        </tr>
                                    </asp:Panel>
                                    <asp:Panel ID="pnKSV" runat="server" Visible="false">
                                        <tr>
                                            <td>Kiểm sát viên<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlKSV_Nguoi" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </asp:Panel>
                                    <asp:Panel ID="pnPhancong" runat="server">
                                        <tr>
                                            <td>Ngày phân công</td>
                                            <td style="width: 250px;">
                                                <asp:TextBox ID="txtNgayphancong" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td style="display: none;">Ngày nhận phân công </td>
                                            <td style="display: none;">
                                                <asp:TextBox ID="txtNhanphancong" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNhanphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNhanphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr style="display: none;">
                                        <td>Ngày kết thúc</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="4" style="text-align: center;">
                                            <asp:Button ID="cmdCapnhaHDXX" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="cmdCapnhaHDXX_Click" />
                                            <asp:Button ID="cmdLammoiHDXX" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoiHDXX_Click" />
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="4">
                                            <div>
                                                <asp:HiddenField ID="hddHdxxid" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbaoTTNguoiTHToTung" ForeColor="Red"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="4">
                                            <div>
                                                <asp:HiddenField ID="HiddenField1" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                            </div>

                                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                                <div runat="server" class="phantrang" visible="False">
                                                    <div class="sobanghi">
                                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                    </div>
                                                    <div class="sotrang">
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
                                                    </div>
                                                </div>
                                                <asp:DataGrid ID="dgList_HDXX" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%"
                                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                TT
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Container.DataSetIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="220px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Vai trò tiến hành tố tụng
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("TENVAITRO") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Tên thẩm phán
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("TENNGUOITHTT") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Thao tác
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                                    </Columns>
                                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                                <div class="phantrang">
                                                    <div class="sobanghi">
                                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                    </div>
                                                    <div class="sotrang">
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
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div style="height: 20px;"></div>
                        <div>
                            <h4 class="tleboxchung">Kết quả giải quyết</h4>
                            <div>
                                <table>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 101px;">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                        
                                        <td style="width: 150px; margin-left: 0px;">
                                            <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="150px" MaxLength="10" AutoPostBack="true" OnTextChanged="cmdSuggestSoQD_Click"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>

                                        <td style="width: 50px; padding-left: 50px;">Số QĐ<span class="batbuoc">(*)</span></td>
                                        <td style="width: 60px;">
                                            <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="60px" MaxLength="25" onkeypress="return isNumber(event);"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                                        <td style="width: 450px;">
                                            <div style="width: 450px;">
                                                <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="250px">
                                                </asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Hiệu lực Từ ngày</td>
                                        <td style="width: 150px; margin-left: 0px;">
                                            <asp:TextBox ID="txtHieuLucTuNgay" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtHieuLucTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtHieuLucTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 50px;">Đến ngày</td>
                                        <td>
                                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="60px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Vụ việc quá hạn luật định ?</td>
                                        <td colspan="3">
                                            <asp:RadioButtonList ID="rdVuAnQuaHan" AutoPostBack="true"
                                                runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Button ID="cmdCapnhatKetqua" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhatKetqua_Click" />
                                            <asp:Button ID="cmXoaKetqua" runat="server" CssClass="buttoninput" Text="Xoá" OnClick="cmdXoaKetqua_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <asp:Label runat="server" ID="lbthongBaoUpdateKetqua" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="height: 200px"></div>

                <script>
                    function ReloadParent() {
                        OnClose();
                    }
                </script>

                <script type="text/javascript">
                    function isNumber(evt) {
                        evt = (evt) ? evt : window.event;
                        var charCode = (evt.which) ? evt.which : evt.keyCode;
                        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                            return false;
                        }
                        return true;
                    }
                    function OnClose() {
                        if (window.opener != null && !window.opener.closed) {
                            window.opener.HideModalDiv();
                        }
                        window.close();
                    }
                    window.onunload = OnClose;

                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                        $('.chosen-container-single').css('width', '100%');
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
