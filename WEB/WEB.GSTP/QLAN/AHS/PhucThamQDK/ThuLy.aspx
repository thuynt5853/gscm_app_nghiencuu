<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="ThuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucThamQDK.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                        <asp:Panel ID="pnGopTach" runat="server" Visible="false">
                            <div style="padding: 10px; margin-bottom: 10px; text-align:center">
                                <div >
                                    <asp:Button ID="btnGop" runat="server" CssClass="buttoninput"
                                        Text="Gộp" OnClick="btnGop_Click" />
                                    <asp:Button ID="btnTach" runat="server" CssClass="buttoninput"
                                        Text="Tách" OnClick="btnTach_Click" />
                                </div>

                            </div>
                        </asp:Panel>


                    </div>

                <!------------------------------------>
                <h4 class="tleboxchung">THỤ LÝ PHÚC THẨM</h4>
                <div class="boder" style="padding: 10px; margin-top: 5PX;">
                    <table class="table1">
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
                                <asp:TextBox ID="txtSoThuLy" CssClass="user"
                                    runat="server" Width="150px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px;">Người ký<span class="batbuoc">(*)</span></td>
                            <td style="width: 125px;">
                                <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
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
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="float: left;">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                        <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput"
                                            Text="Làm mới" OnClick="cmdThemmoi_Click" />
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
    <script>
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function validate() {
            var ddTruongHopTL = document.getElementById('<%=ddTruongHopTL.ClientID%>');
            value_change = ddTruongHopTL.options[ddTruongHopTL.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!');
                ddTruongHopTL.focus();
                return false;
            }

            var txtSoThuLy = document.getElementById('<%=txtSoThuLy.ClientID%>');
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
