<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CacQDKhac.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.QDKhac.CacQDKhac" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddcurID" runat="server" />
    <asp:HiddenField ID="hddindex" runat="server" />
    <asp:HiddenField ID="hddpage" runat="server" />
    <asp:Panel ID="pn" runat="server">
    <div class="box_nd">
        <div class="boxchung">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
            <h4 class="tleboxchung">Thông tin quyết định</h4>
            <div class="boder" style="padding: 10px;">
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <table class="table1">
                    <tr>
                        <td style="width: 120px;">Mã quyết định <span class="batbuoc">(*)</span>
                        </td>
                        <td style="width: 230px;">
                            <asp:TextBox ID="txtMaQD" runat="server" Width="200px" CssClass="user"></asp:TextBox>
                        </td>
                        <td style="width: 120px">Tòa án<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtToaAn" Width="200px"
                                runat="server" Enabled="false" CssClass="user"></asp:TextBox>
                            <asp:HiddenField ID="hddToaAnID" runat="server" />
                        </td>
                    </tr>

                    <%------%>
                    <tr>
                        <td>Loại quyết định<span class="batbuoc">(*)</span>
                        </td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlLoaiQD" runat="server" CssClass="chosen-select"
                                Width="575px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Số quyết định/TB<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtSoQD" runat="server" Width="200px" CssClass="user"></asp:TextBox>
                        </td>
                        <td>Ngày ra quyết định/TB<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNgayRaQD" runat="server" Width="200px" CssClass="user"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayRaQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayRaQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayRaQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <%------%>

                    <tr>
                        <td>Hiệu lực từ ngày<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtHieuLuc_TuNgay" runat="server" Width="200px" CssClass="user" placeholder="ngày/tháng/năm" AutoPostBack="True" OnTextChanged="txtHieuLuc_TuNgay_TextChanged"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtHieuLuc_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtHieuLuc_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtHieuLuc_TuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <%------%>
                    <tr>
                        <td>Thời hạn theo luật định                          
                        </td>
                        <td>
                            <asp:TextBox ID="txtThang_TheoLuat" runat="server"
                                Width="50px" CssClass="user align_right"
                                onkeypress=" return isNumber(event)"
                                AutoPostBack="true" OnTextChanged="txtThang_TheoLuat_TextChanged"></asp:TextBox>
                            Tháng
                            &nbsp;
                            <asp:TextBox ID="txtNgay_TheoLuat" runat="server" Width="50px" CssClass="user align_right" Text="15" AutoPostBack="true" onkeypress="return isNumber(event)" OnTextChanged="txtNgay_TheoLuat_TextChanged"></asp:TextBox>
                            Ngày
                        </td>
                        <td>Ngày kết thúc theo luật định<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtKetThucTheoLuat" runat="server"
                                Width="200px" CssClass="user" placeholder="ngày/tháng/năm"
                                AutoPostBack="true" OnTextChanged="txtKetThucTheoLuat_TextChanged"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtKetThucTheoLuat" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtKetThucTheoLuat" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtKetThucTheoLuat" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <%------%>
                    <tr>
                        <td>Thời hạn thực tế                           
                        </td>
                        <td>
                            <asp:TextBox ID="txtThangThucTe" runat="server" Width="50px" CssClass="user align_right" AutoPostBack="true"
                                onkeypress="return isNumber(event)" MaxLength="2" OnTextChanged="txtThangThucTe_TextChanged"></asp:TextBox>
                            Tháng
                            &nbsp;
                            <asp:TextBox ID="txtNgayThucTe" runat="server" Width="50px" CssClass="user align_right" Text="15" AutoPostBack=" true"
                                onkeypress="return isNumber(event)" MaxLength="2" OnTextChanged="txtNgayThucTe_TextChanged"></asp:TextBox>
                            Ngày
                        </td>
                        <td>Hiệu lực đến ngày<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgayHieuLuc_DenNgay" runat="server" Width="200px"
                                placeholder="ngày/tháng/năm" CssClass="user"
                                AutoPostBack="true" OnTextChanged="txtNgayHieuLuc_DenNgay_TextChanged"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayHieuLuc_DenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>

                    </tr>
                    <%------%>
                    <tr>
                        <td>Người kí</td>
                        <td>
                            <asp:HiddenField ID="hddLoadID" runat="server" />
                            <asp:DropDownList ID="ddlNguoiki" runat="server" CssClass="chosen-select"
                                Width="200px" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlNguoiki_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td>Chức vụ</td>
                        <td>
                            <asp:TextBox ID="txtChucVu" runat="server" Width="200px" CssClass="user" disabled="disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Ghi chú</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtGhichu" runat="server" Width="568px" CssClass="user"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div style="padding-top: 10px; text-align: center; width: 95%">
        <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
            Text="Lưu" OnClientClick="return ValidInputData();" OnClick="cmdUpdateVuAn_Click" />

        <asp:Button ID="cmdResert" runat="server" CssClass="buttoninput"
            Text="Làm mới" OnClick="cmdResert_Click" />
    </div>
    <div>
        <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
            <br />
            <asp:Label ID="lbthongbaoupdate" runat="server" Text="" ForeColor="Red"></asp:Label>
        </div>
    </div>

    <asp:Panel runat="server" ID="pndata" Visible="false">
        <div style="float: left; width: 98%; margin: 0px 1%; margin-bottom: 10px;">
            <!---Danh sách các quyết định khác-->
            <div style="padding-top: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="Literal1" runat="server"></asp:Literal>
            </div>

            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="6"
                AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand"  OnItemDataBound="dgList_ItemDataBound">
                <Columns>
                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                    <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            STT
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="120px"
                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Mã quyết định
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("MAQD") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="150px"
                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Số quyết định
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("SOQD") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                        HeaderStyle-Width="150px" ItemStyle-Width="150px"
                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Ngày quyết định/TB
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# String.Format("{0:dd/MM/yyyy}", Eval("NGAYQD"))%>
                        </ItemTemplate>
                    </asp:TemplateColumn>

                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"
                        ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Loại quyết định
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("LoaiQuyetDinh")%>
                        </ItemTemplate>
                    </asp:TemplateColumn>

                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px"
                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Thao tác
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                CommandName="Sua" ForeColor="#0e7eee"
                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                Text="Xóa" ForeColor="#0e7eee"
                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                </Columns>
                <HeaderStyle CssClass="header"></HeaderStyle>
                <ItemStyle CssClass="chan"></ItemStyle>
                <PagerStyle Visible="false"></PagerStyle>
            </asp:DataGrid>
        </div>
    </asp:Panel>
    </asp:Panel>

    <div style="width: 100%; float: left;">

        <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script>
        function ValidInputData() {
            var txtMaQD = document.getElementById('<%=txtMaQD.ClientID%>');
            if (!Common_CheckTextBox(txtMaQD, "Mã quyết định"))
                return false;

            var ddlLoaiQD = document.getElementById('<%=ddlLoaiQD.ClientID%>');
            value_change = ddlLoaiQD.options[ddlLoaiQD.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn loại quyết định. Hãy kiểm tra lại!');
                ddlLoaiQD.focus();
                return false;
            }

            var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
            if (!Common_CheckTextBox(txtSoQD, "Số quyết định"))
                return false;

            var txtNgayRaQD = document.getElementById('<%=txtNgayRaQD.ClientID%>');
            if (!CheckDateTimeControl(txtNgayRaQD, 'Ngày ra quyết định/TB'))
                return false;

            var txtHieuLuc_TuNgay = document.getElementById('<%=txtHieuLuc_TuNgay.ClientID%>');
            if (!CheckDateTimeControl(txtHieuLuc_TuNgay, 'mục "Hiệu lực từ ngày"'))
                return false;

            var NgaySoSanh = txtNgayRaQD.value;
            if (!SoSanh2Date(txtHieuLuc_TuNgay, 'mục "Hiệu lực từ ngày"', NgaySoSanh, 'mục "Ngày ra quyết đinh/TB"')) {
                txtHieuLuc_TuNgay.focus();
                return false;
            }
            //--------------
            var txtKetThucTheoLuat = document.getElementById('<%=txtKetThucTheoLuat.ClientID%>');
            if (!Common_CheckEmpty(txtKetThucTheoLuat.value)) {
                alert('Mục "Ngày kết thúc theo luật định" không được bỏ trống');
                txtKetThucTheoLuat.focus();
                return false;
            }

            var NgaySoSanh = txtHieuLuc_TuNgay.value;
            if (!SoSanh2Date(txtKetThucTheoLuat, 'Ngày kết thúc theo luật định', NgaySoSanh, 'mục "Hiệu lực từ ngày"')) {
                txtKetThucTheoLuat.focus();
                return false;
            }
            //---------------------------
            var txtNgayHieuLuc_DenNgay = document.getElementById('<%=txtNgayHieuLuc_DenNgay.ClientID%>');
            if (!Common_CheckEmpty(txtNgayHieuLuc_DenNgay.value)) {
                alert('Mục "Hiệu lực đến ngày" không được bỏ trống');
                txtNgayHieuLuc_DenNgay.focus();
                return false;
            }

            NgaySoSanh = txtHieuLuc_TuNgay.value;
            if (!SoSanh2Date(txtNgayHieuLuc_DenNgay, 'Mục "Hiệu lực đến ngày"', NgaySoSanh, 'mục "Hiệu lực từ ngày"')) {
                txtNgayHieuLuc_DenNgay.focus();
                return false;
            }
            //----------------------------------
            var ddlNguoiki = document.getElementById('<%=ddlNguoiki.ClientID%>');
            value_change = ddlNguoiki.options[ddlNguoiki.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn người ký. Hãy kiểm tra lại!');
                ddlNguoiki.focus();
                return false;
            }

            return true;
        }
    </script>



</asp:Content>
