<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="ThuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />

    <style>
        .CustomWidth {
        }

        .modalPopup .header {
            background-color: #a4212a;
            height: 30px;
            color: White;
            line-height: 22px;
            text-align: center;
            font-weight: bold;
        }
    </style>

    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
    <style>
        .align_right {
            text-align: right;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">XÉT XỬ SƠ THẨM</h4>

                    <div class="boder" style="padding: 10px; margin-bottom: 10px;">
                        <b>Thông tin Hồ sơ Sơ thẩm</b>
                        <div style="padding: 10px; margin-bottom: 10px;">
                            <asp:Label ID="lblBAQD" runat="server" CssClass="user" Width="80px" MaxLength="10"></asp:Label>
                            &nbsp;
                             <asp:Label ID="lblNgayBAQD" runat="server" CssClass="user" Width="140px" MaxLength="10"></asp:Label>
                            &nbsp;
                            <asp:Label ID="lblToaxx" runat="server" CssClass="user" Width="300px" MaxLength="10"></asp:Label>

                            <asp:Repeater ID="rptToaSoTham" runat="server">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="42">
                                                <div align="center"><strong>TT</strong></div>
                                            </td>
                                            <td width="70px">
                                                <div align="center"><strong>BC đầu vụ</strong></div>
                                            </td>
                                            <td style="width: 20%">
                                                <div align="center"><strong>Bị can</strong></div>
                                            </td>

                                            <td width="70px">
                                                <div align="center"><strong>Năm sinh</strong></div>
                                            </td>
                                            <td width="100px">
                                                <div align="center"><strong>Ngày tham gia</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Tội danh chính</strong></div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("STT") %></td>
                                        <td>
                                            <div align="center">
                                                <asp:CheckBox ID="chk" runat="server" Enabled="false" Checked='<%# (Convert.ToInt16(Eval("BICANDAUVU"))>0)? true:false %>' />
                                            </div>
                                        </td>
                                        <td><%#Eval("TenBiCao") %>
                                            <%# String.IsNullOrEmpty( Eval("DCTamTru") +"") ? "":( "<br/><b>Tạm trú:</b> " +Eval("DCTamTru"))%>
                                        </td>
                                        <td><%# Eval("NamSinh") %></td>
                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThamGia")) %></td>
                                        <td><%# Eval("TenToiDanh") %></td>

                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <!------------------------------------>
                        <asp:Panel ID="pnKC" runat="server">
                            <b class="tleboxchung">Kháng cáo</b>
                            <div style="padding: 10px; margin-bottom: 10px;">
                                <asp:Repeater ID="rptKC" runat="server">
                                    <HeaderTemplate>
                                        <table class="table2" style="width: 100%;" border="1">
                                            <tr class="header">
                                                <td style="width: 30px;">
                                                    <div style="text-align: center;"><strong>TT</strong></div>
                                                </td>
                                                <td style="width: 180px;">
                                                    <div style="text-align: center;"><strong>Người kháng cáo</strong></div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center;"><strong>Nội Dung</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="text-align: center"><%# Container.ItemIndex + 1 %></td>
                                            <td><%#Eval("NguoiKCCapKN") %></td>
                                            <td><%#Eval("NOIDUNG") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                        <!------------------------------------>
                        <asp:Panel ID="pnKN" runat="server">
                            <b class="tleboxchung">Kháng nghị</b>
                            <div style="padding: 10px; margin-bottom: 10px;">
                                <asp:Repeater ID="rptKN" runat="server">
                                    <HeaderTemplate>
                                        <table class="table2" style="width: 100%;" border="1">
                                            <tr class="header">
                                                <td style="width: 30px;">
                                                    <div style="text-align: center"><strong>TT</strong></div>
                                                </td>
                                                <td style="width: 100px;">
                                                    <div style="text-align: center"><strong>Cấp kháng nghị</strong></div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center"><strong>Nội dung</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="text-align: center"><%# Container.ItemIndex + 1 %></td>
                                            <td><%#Eval("NguoiKCCapKN") %></td>
                                            <td><%#Eval("NOIDUNG") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                    </div>

                    <!------------------------------------>
                    <h4 class="tleboxchung">THỤ LÝ PHÚC THẨM</h4>
                    <div class="boder" style="padding: 10px; margin-top: 5PX;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <div class="danhsach">
                                        <asp:Repeater ID="rptThuLyPT" runat="server" OnItemCommand="rptThuLyPT_ItemCommand" OnItemDataBound="rptThuLyPT_ItemDataBound">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td width="42">
                                                            <div align="center"><strong>TT</strong></div>
                                                        </td>
                                                        <td width="70px">
                                                            <div align="center"><strong>BC đầu vụ</strong></div>
                                                        </td>
                                                        <td style="width: 20%">
                                                            <div align="center"><strong>Bị can</strong></div>
                                                        </td>

                                                        <td width="70px">
                                                            <div align="center"><strong>Năm sinh</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Tội danh chính xét xử phúc thẩm</strong></div>
                                                        </td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:HiddenField ID="BICAOID" runat="server" Value='<%# Eval("BICAOID") %>' />
                                                <tr>
                                                    <td><%# Eval("STT") %></td>
                                                    <td>
                                                        <div align="center">
                                                            <asp:CheckBox ID="chk" runat="server" Enabled="false" Checked='<%# (Convert.ToInt16(Eval("BICANDAUVU"))>0)? true:false %>' />
                                                        </div>
                                                    </td>
                                                    <td><%#Eval("HOTEN") %>
                                                        <%# String.IsNullOrEmpty( Eval("DCTamTru") +"") ? "":( "<br/><b>Tạm trú:</b> " +Eval("DCTamTru"))%>
                                                    </td>
                                                    <td><%# Eval("NamSinh") %></td>

                                                    <td>
                                                        <asp:Label ID="lblToiDanhChinhPT" runat="server"
                                                            Text='<%# Eval("TOIDANHCHINHXXPT") %>'></asp:Label></td>
                                                    <td>
                                                        <div align="center">
                                                            <asp:LinkButton ID="lblChon" runat="server" CausesValidation="false" Text="Chọn" ForeColor="#0e7eee"
                                                                CommandName="Chon" CommandArgument='<%#Eval("BICAOID") %>' ToolTip="Chọn"></asp:LinkButton>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 115px;">Trường hợp thụ lý<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddTruongHopTL" CssClass="chosen-select"
                                        runat="server" Width="377px">
                                    </asp:DropDownList></td>
                                <td colspan="2">
                                    <asp:CheckBox ID="cbUTTP" Checked="false" runat="server" Text="Ủy thác tư pháp đi" /></td>
                            </tr>
                            <tr>
                                <asp:Panel ID="pnlNoidung" runat="server" Visible="false">
                                    <td style="width: 115px;">Nội dung</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNoidung" CssClass="chosen-select"
                                            runat="server" Width="377px" AutoPostBack="true" OnSelectedIndexChanged="ddlNoidung_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </asp:Panel>
                                <asp:Panel ID="pnlGhichu" runat="server" Visible="false">
                                    <td style="width: 80px;">Ghi chú</td>
                                    <td>
                                        <asp:TextBox ID="txtGhichu" CssClass="user"
                                            runat="server" Width="377px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </asp:Panel>
                            </tr>

                            <tr>
                                <td style="width: 80px;">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                                <td style="width: 125px;">
                                    <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user" Width="100px" MaxLength="10"
                                        onkeypress="return isNumber(event)"
                                        AutoPostBack="True" OnTextChanged="txtNgayThuLy_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayThuLy"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayThuLy"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td style="width: 80px;">Số thụ lý<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtSoThuly" CssClass="user" runat="server"
                                        Width="242px" MaxLength="250"></asp:TextBox>
                                    <asp:DropDownList ID="ddlSothuly" CssClass="user" runat="server" Width="186px">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlStlPhu" CssClass="user" runat="server" Width="54px">
                                        <asp:ListItem Value="" Text="" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="A" Text="A"></asp:ListItem>
                                        <asp:ListItem Value="B" Text="B"></asp:ListItem>
                                        <asp:ListItem Value="C" Text="C"></asp:ListItem>
                                        <asp:ListItem Value="D" Text="D"></asp:ListItem>
                                        <asp:ListItem Value="E" Text="E"></asp:ListItem>
                                    </asp:DropDownList>
                            </tr>
                            <tr>
                                <td style="width: 80px">Tội danh chính của vụ án<span class="batbuoc">(*)</span>
                                </td>
                                <td style="width: 125px">
                                    <asp:DropDownList ID="ddlToiDanhVuAn" CssClass="chosen-select" runat="server" Width="250px" Enabled="false"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 80px;">Người ký<span class="batbuoc">(*)</span></td>
                                <td style="width: 125px;">
                                    <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                </td>
                                <td style="width: 80px;">Người kiểm hồ sơ</td>
                                <td>
                                    <asp:DropDownList ID="ddlCanbokiemhoso" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 80px;">Số bút lục</td>
                                <td>
                                    <asp:TextBox ID="txtSoButLuc" CssClass="user" runat="server" Width="250px" MaxLength="150"></asp:TextBox>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>Từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtTuNgay" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTuNgay"
                                        Format="dd/MM/yyyy" Enabled="false" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtTuNgay"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                </td>
                                <td>Đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user"
                                        onkeypress="return isNumber(event)" Width="120px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                        TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                        TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="float: left;">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                        <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput"
                                            Text="Làm mới" OnClick="cmdThemmoi_Click" />
                                        <asp:Button ID="btnLichsuXoaThuly" runat="server" CssClass="buttoninput" Text="Lịch sử xóa" OnClick="btnLichsuXoaThuly_Click" />
                                    </div>
                                    <div style="float: left; margin: 5px; width: 95%; color: red;">
                                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>

                        <div class="danhsach">
                            <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="42">
                                                <div align="center"><strong>TT</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Số thụ lý</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Trường hợp thụ lý</strong></div>
                                            </td>
                                            <td width="10%">
                                                <div align="center"><strong>Ngày thụ lý</strong></div>
                                            </td>
                                            <td width="10%">
                                                <div align="center"><strong>Từ ngày</strong></div>
                                            </td>
                                            <td width="10%">
                                                <div align="center"><strong>Đến ngày</strong></div>
                                            </td>

                                            <td width="70">
                                                <div align="center"><strong>Thao tác</strong></div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="text-align: center"><%# Container.ItemIndex + 1 %></td>
                                        <td><%#Eval("SoThuLy") %></td>
                                        <td><%#Eval("TruongHopThuLy") %></td>
                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThuLy")) %></td>
                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("ThoiHanTuNgay")) %></td>
                                        <td><%# (String.IsNullOrEmpty(Eval("ThoiHanDenNgay")+"") || Convert.ToDateTime(Eval("ThoiHanDenNgay")+"") == DateTime.MinValue)? "": string.Format("{0:dd/MM/yyyy}", Eval("ThoiHanDenNgay")) %></td>
                                        <td>
                                            <div align="center">
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoaSothulyKhongSuDungLai" runat="server" CausesValidation="false" Text="Xóa số thụ lý" ForeColor="#0e7eee"
                                                    CommandName="XoaSothulyKhongSuDungLai" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"></asp:LinkButton>
                                            </div>
                                        </td>
                                        <td style="display: none;">
                                            <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div runat="server" id="modalpopupCapnhat" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mp1" BehaviorID="mp1_Capnhat"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="modalpopupCapnhat"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 150px; width: 550px;">
        <div class="box_nd" style="width: 500px; display: none;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="pnCapnhat_Tieude" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <asp:HiddenField ID="hddXoa_SelectedIndex" runat="server" Value="0" />
                <asp:HiddenField ID="hddThulyID" runat="server" Value="0" />

                <div>
                    <div>
                        <table>
                            <tr>

                                <td>Lý do xóa<span class="batbuoc">(*)</span></td>
                                <td style="padding-left: 5px;">
                                    <asp:DropDownList ID="ddlLydoXoaSothuly" CssClass="user" runat="server" Style="width: 300px; text-align: center">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <asp:Button ID="btnSaveLydoXoa" runat="server" CssClass="buttoninput" Text="Xóa và đóng" OnClick="btnSaveLydoXoa_Insert" OnClientClick="javascript:HideModalPopup();" />
                                    <asp:Button ID="btnClose" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="javascript:HideModalPopup();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>

    <div runat="server" id="modalpopupLichsuXoaThuly" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mdLichsuXoaThuly" BehaviorID="mp_LichsuXoaThuly"
        runat="server" PopupControlID="pnLichsuXoaThuly"
        TargetControlID="modalpopupLichsuXoaThuly"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnLichsuXoaThuly" runat="server" align="center" CssClass="modalPopup" Style="height: 500px; width: 550px; overflow-y: scroll;">

        <div class="box_nd" style="width: 500px;">
            <div class="truong">
                <div>
                    <div>
                        <table>
                            <tr>
                                <td>

                                    <asp:DataGrid ID="dgLichsuXoaThuly" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%">
                                        <Columns>
                                            <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    TT
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Container.DataSetIndex + 1 %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Số/ngày thụ lý
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("SOTHULY") %><br />
                                                    <%# Eval("NGAYTHULY", "{0:dd/MM/yyyy}") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Lý do xóa
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("LYDO") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Người xóa/Ngày xóa
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TAIKHOANXOA") %><br />
                                                    <%#Eval("NGAYXOA") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                        <ItemStyle CssClass="chan"></ItemStyle>
                                        <PagerStyle Visible="false"></PagerStyle>
                                    </asp:DataGrid>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <asp:Button ID="btnCloseLichsuXoaThuly" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="javascript:HideModalPopup();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>

    <div id="popupChonToiDanhChinh" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border: 2px solid #ccc; z-index: 1000; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); min-width: 700px;">
        <div style="font-size: 16px; font-weight: bold; margin-bottom: 16px;">
            Chọn tội danh chính
        </div>

        <asp:Repeater ID="dgToiDanhChinh" runat="server">
            <HeaderTemplate>
                <table class="table2" width="100%" border="1">
                    <tr class="header">
                        <td width="42" align="center"><strong>STT</strong></td>
                        <td width="150px" align="center"><strong>Bộ luật</strong></td>
                        <td width="50px" align="center"><strong>Điều</strong></td>
                        <td width="50px" align="center"><strong>Khoản</strong></td>
                        <td width="50px" align="center"><strong>Điểm</strong></td>
                        <td align="center"><strong>Tội danh</strong></td>
                        <td width="60px" align="center"><strong>Là tội danh chính</strong></td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td align="center"><%# Eval("STT") %></td>
                    <td><%# Eval("TenBoLuat") %></td>
                    <td><%# Eval("Dieu") %></td>
                    <td><%# Eval("Khoan") %></td>
                    <td><%# Eval("Diem") %></td>
                    <td><%# Eval("TENTOIDANH") %></td>
                    <td align="center">
                        <asp:HiddenField ID="hddID_ToiDanh" runat="server" Value='<%# Eval("TOIDANHID") %>' />
                        <asp:HiddenField ID="hdd_IsBanAn" runat="server" Value='<%# Eval("ISBANAN") %>' />
                        <asp:CheckBox ID="chkLuaChon" runat="server" InputAttributes-CssClass="chkLuaChon" Checked='<%# CheckToiDanh(Eval("ISMAIN_THULYPT")) %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <div align="center">
            <asp:Label runat="server" ID="lbThongBao_chonTDC" ForeColor="Red"></asp:Label><br />
            <asp:Button ID="btnSaveTDC" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnSaveTDC_Click" OnClientClick="return validateToiDanh();" />
            <input type="button" class="buttoninput" onclick="anPopup();" value="Đóng" />
        </div>
    </div>
    <!-- Nền mờ khi hiển thị popup -->
    <div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0, 0, 0, 0.5); /*  màu nền tối mờ */
            z-index: 999; /* dưới popup một lớp */">
    </div>
    <script type="text/javascript">
        function hienPopup() {
            document.getElementById("popupChonToiDanhChinh").style.display = "block";
            document.getElementById("overlay").style.display = "block";
        }

        function anPopup() {
            document.getElementById("popupChonToiDanhChinh").style.display = "none";
            document.getElementById("overlay").style.display = "none";
        }

        function validateToiDanh() {
            debugger;
            var checkboxes = document.querySelectorAll("input[type='checkbox'][name*='chkLuaChon']:checked");
            var count = checkboxes.length;
            var label = document.getElementById('<%=lbThongBao_chonTDC.ClientID%>');

            if (count === 0) {
                label.innerText = "Bạn chưa chọn bản ghi nào!";
                return false;
            }
            if (count > 1) {
                label.innerText = 'Chỉ được chọn 1 bản ghi là tội danh chính!';
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function HideModalPopup() {
            $find("mp1_Capnhat").hide();
            return false;
        }
    </script>

    <script>
        var value_change = "";
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function validate() {
            var ddlToiDanhChinh = document.getElementById('<%=ddlToiDanhVuAn.ClientID%>');
            value_change = ddlToiDanhChinh.options[ddlToiDanhChinh.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn tội danh chính của vụ án. Hãy kiểm tra lại!');
                ddlToiDanhChinh.focus();
                return false;
            }

            // Kiểm tra tất cả các dòng tội danh chính xét xử phúc thẩm không rỗng
            var invalidCount = 0;
            var labels = document.querySelectorAll('[id*="lblToiDanhChinhPT"]');
            if (labels.length === 0) {
                alert('Danh sách bị cáo phúc thẩm chưa được tải, hãy kiểm tra lại!');
                return false;
            }
            labels.forEach(function (lb) {
                var txt = (lb.innerText || lb.textContent || '').trim();
                if (txt === '' || txt === '&nbsp;') {
                    invalidCount++;
                }
            });
            if (invalidCount > 0) {
                alert('Bạn phải chọn tội danh chính xét xử phúc thẩm cho tất cả bị cáo trước khi lưu.');
                return false;
            }

            var ddTruongHopTL = document.getElementById('<%=ddTruongHopTL.ClientID%>');
            value_change = ddTruongHopTL.options[ddTruongHopTL.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!');
                ddTruongHopTL.focus();
                return false;
            }


            var txtSoThuLy = document.getElementById('<%=txtSoThuly.ClientID%>');
            if (!Common_CheckEmpty(txtSoThuLy.value)) {
                alert('Bạn chưa nhập số thụ lý. Hãy kiểm tra lại!');
                txtSoThuLy.focus();
                return false;
            }

            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThuLy, 'Ngày thụ lý'))
                return false;

            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
