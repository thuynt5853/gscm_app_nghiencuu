<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="ThuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.SoTham.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>

    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />

    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
    <style>
        .align_right {
            text-align: right;
        }

        #canhbao_form {
            background-color: #fff478;
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 0 3px rgba(0, 0, 0, 0.2);
            width: 90%;
            min-height: 30px;
            line-height: 30px;
            opacity: 0.9;
            z-index: 10;
            float: left;
            font-weight: bold;
            padding: 5px;
        }

            #canhbao_form ul li {
                float: left;
                width: 100%;
                margin: 0;
                padding: 0;
                margin-left: 3%;
            }

        .canhbao_thuly {
            color: red;
            margin-left: 3px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin thụ lý</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 115px;">Trường hợp thụ lý<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddTruongHopTL" CssClass="chosen-select"
                                        runat="server" Width="377px" AutoPostBack="true" OnSelectedIndexChanged="ddTruongHopTL_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td colspan="2">
                                    <asp:CheckBox ID="cbUTTP" Checked="false" runat="server" Text="Ủy thác tư pháp đi" /></td>
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

                                </td>
                            </tr>
                            <asp:Panel ID="pnlNoidung" runat="server" Visible="false">
                                <tr>
                                    <td style="width: 115px;">Nội dung</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNoidung" CssClass="chosen-select"
                                            runat="server" Width="377px" AutoPostBack="true" OnSelectedIndexChanged="ddlNoidung_SelectedIndexChanged">
                                            <%--                                            <asp:ListItem Value="0" Text="--Chọn--" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2241" Text="Xét xử lại phần Dân sự"></asp:ListItem>
                                            <asp:ListItem Value="2242" Text="Xét xử lại phần bồi thường"></asp:ListItem>
                                            <asp:ListItem Value="2243" Text="Xét xử lại toàn bộ bản án"></asp:ListItem>
                                            <asp:ListItem Value="2244" Text="Khác"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </td>
                                    <asp:Panel ID="pnlGhichu" runat="server" Visible="false">
                                        <td style="width: 80px;">Ghi chú</td>
                                        <td>
                                            <asp:TextBox ID="txtGhichu" CssClass="user"
                                                runat="server" Width="400px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                </tr>
                            </asp:Panel>

                            <asp:Panel ID="pnTTCaoTrang" runat="server" Visible="false">
                                <tr>

                                    <td>Ngày bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanCaoTrang" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBanCaoTrang" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBanCaoTrang" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Số bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanCaoTrang" runat="server"
                                            CssClass="user align_right"
                                            Width="162px" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr style="display: none;">
                                <td>Từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px"
                                        onkeypress="return isNumber(event)"
                                        MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server"
                                        TargetControlID="txtTuNgay"
                                        Format="dd/MM/yyyy" Enabled="false" />
                                    <cc1:MaskedEditExtender ID="txtTuNgay_MaskedEditExtender" runat="server" TargetControlID="txtTuNgay"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user"
                                        onkeypress="return isNumber(event)"
                                        Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                        TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                        TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date"
                                        CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <asp:Literal ID="lttCanhBao" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="2">
                                    <div style="margin: 5px; text-align: center; width: 95%">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                        <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput"
                                            Text="Làm mới" OnClick="cmdThemmoi_Click" />
                                        <asp:Button ID="btnLichsuXoaThuly" runat="server" CssClass="buttoninput" Text="Lịch sử xóa" OnClick="btnLichsuXoaThuly_Click" />
                                    </div>

                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div style="width: 95%; color: red;">
                                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="danhsach">

                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                        <HeaderTemplate>
                            <table class="table2" width="100%" border="1">
                                <tr class="header">
                                    <td width="42">
                                        <div align="center"><strong>TT</strong></div>
                                    </td>
                                    <td width="150px">
                                        <div align="center"><strong>Số thụ lý</strong></div>
                                    </td>
                                    <td>
                                        <div align="center"><strong>Trường hợp thụ lý</strong></div>
                                    </td>
                                    <td width="10%">
                                        <div align="center"><strong>Ngày thụ lý</strong></div>
                                    </td>
                                    <td width="70px">
                                        <div align="center"><strong>Thao tác</strong></div>
                                    </td>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Container.ItemIndex + 1 %></td>
                                <td><%#Eval("SoThuLy") %></td>
                                <td><%#Eval("TruongHopThuLy") %></td>
                                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThuLy")) %></td>
                                <td>
                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    <br />
                                    <asp:LinkButton ID="lbtXoa" runat="server"
                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"></asp:LinkButton>
                                    <br />
                                    <asp:LinkButton ID="lbtXoaSothulyKhongSuDungLai" runat="server" CausesValidation="false" Text="Xóa số thụ lý" ForeColor="#0e7eee"
                                        CommandName="XoaSothulyKhongSuDungLai" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"></asp:LinkButton>
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

    <div runat="server" id="modalpopupCapnhat" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mp1" BehaviorID="mp1_Capnhat"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="modalpopupCapnhat"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 150px; width: 550px;">

        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <asp:HiddenField ID="hddXoa_SelectedIndex" runat="server" Value="0" />
                <asp:HiddenField ID="hddThulyID" runat="server" Value="0" />
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

    <script type="text/javascript">
        function HideModalPopup() {
            $find("mp1_Capnhat").hide();
            return false;
        }
    </script>

    <script>
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function validate() {
            <%--var NgayHoSo = '<%= NgayHoSo%>';--%>

            var ddTruongHopTL = document.getElementById('<%=ddTruongHopTL.ClientID%>');
            value_change = ddTruongHopTL.options[ddTruongHopTL.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!');
                ddTruongHopTL.focus();
                return false;
            }
            //------------------------------------
            var txtSoThuLy = document.getElementById('<%=txtSoThuly.ClientID%>');
            if (!Common_CheckTextBox(txtSoThuLy, "Số thụ lý")) {
                return false;
            }
            //------------------------------------
            if (value_change == "233") {
                var txtSoBanCaoTrang = document.getElementById('<%=txtSoBanCaoTrang.ClientID%>');
                if (!Common_CheckEmpty(txtSoBanCaoTrang.value)) {
                    alert('Bạn chưa nhập số bản cáo trạng. Hãy kiểm tra lại!');
                    txtSoBanCaoTrang.focus();
                    return false;
                }
                else {
                    var lengthSoBanCaoTrang = txtSoBanCaoTrang.value.length;
                    if (lengthSoBanCaoTrang > 250) {
                        alert('Số bản cáo trạng không được quá 250 ký tự. Hãy kiểm tra lại!');
                        txtSoBanCaoTrang.focus();
                        return false;
                    }
                }

                var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
                if (!CheckDateTimeControl(txtNgayBanCaoTrang, 'Ngày bản cáo trạng'))
                    return false;
            }


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
    <%--<script>
         function hide_zone_message() {
             var today = new Date();
             var zone = document.getElementById('canhbao_form');
             if (zone.style.display != "") {
                 zone.style.display = "none";
                 zone.innerText = "";
             }
             var t = setTimeout(hide_zone_message, 5000);
         }
         hide_zone_message();
        </script>--%>
</asp:Content>


