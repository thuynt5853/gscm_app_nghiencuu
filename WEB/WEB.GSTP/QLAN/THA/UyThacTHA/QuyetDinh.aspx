<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QuyetDinh.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.UyThacTHA.QuyetDinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddcurID" runat="server" Value="0" />
    <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddindex" runat="server" Value="1" />
    <asp:HiddenField ID="hddpage" runat="server" Value="20" />

    <style>
        .header td div {
            text-align: center;
            font-weight: bold;
            float: left;
            width: 100%;
        }
        .boxchung{
            margin-bottom: 110px;
        }
    </style>
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
                        <td style="width: 130px;">Mã quyết định 
                        </td>
                        <td style="width: 230px">
                            <asp:TextBox ID="txtMaQD" runat="server" Width="200px" CssClass="user"></asp:TextBox>
                        </td>
                        <td style="width: 140px">Quyết định/Thông báo<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtQDvaTB" runat="server" Width="250px" CssClass="user"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Tòa án ủy thác<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtUy_thac" Width="200px" runat="server" Enabled="false" CssClass="user"></asp:TextBox>
                        </td>
                        <td>Tòa án nhận ủy thác <span class="batbuoc">(*)</span>&nbsp;                           
                        </td>
                        <td>
                            <asp:HiddenField ID="hddToaAnUyThacID" runat="server" />
                            <asp:TextBox ID="txtToaAnUyThac" CssClass="user" runat="server" Width="250px" placeholder="Gõ mã hoặc tên để chọn tòa án nhận ủy thác"
                                MaxLength="250" AutoCompleteType="Search"></asp:TextBox></td>

                    </tr>
                    <tr>
                        <td>Số QĐ/TB<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtSoQuyDinh" runat="server" Width="200px" CssClass="user"></asp:TextBox></td>
                        <td>Ngày ra QĐ/TB<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNgayRaQD" runat="server" Width="250px"
                                AutoPostBack="true" OnTextChanged="txtNgayRaQD_TextChanged"
                                CssClass="user" placeholder="dd/MM/yyyy"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayRaQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayRaQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayRaQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Người ký<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:HiddenField ID="hddLoadID" runat="server" />
                            <asp:DropDownList ID="ddlNguoiki" runat="server" CssClass="chosen-select"
                                Width="208px" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlNguoiki_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td>Chức vụ </td>
                        <td>
                            <asp:TextBox ID="txtChucVu" runat="server" Width="250px" CssClass="user" disabled="disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <%------%>
                    <tr>
                        <td colspan="4" style="height: 5px;"></td>
                    </tr>
                    <tr>
                        <td>Hiệu lực từ ngày<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtHieuLuc_TuNgay" runat="server" Width="200px"
                                CssClass="user" placeholder="dd/MM/yyyy"
                                AutoPostBack="True" OnTextChanged="txtHieuLuc_TuNgay_TextChanged"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtHieuLuc_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtHieuLuc_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtHieuLuc_TuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td>Thời hạn theo luật định </td>
                        <td>
                            <asp:TextBox ID="txtThang_TheoLuat" runat="server"
                                Width="50px" CssClass="user align_right"
                                onkeypress=" return isNumber(event)"
                                AutoPostBack="true" OnTextChanged="txtThang_TheoLuat_TextChanged"></asp:TextBox>
                            Tháng
                            &nbsp;&nbsp;
                            <asp:TextBox ID="txtNgay_TheoLuat" runat="server" Width="50px"
                                CssClass="user align_right" Text="15"
                                AutoPostBack="true" onkeypress="return isNumber(event)"
                                OnTextChanged="txtNgay_TheoLuat_TextChanged"></asp:TextBox>
                            Ngày
                        </td>
                        <td>Ngày kết thúc theo luật định <span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtKetThucTheoLuat" runat="server" Width="250px"
                                CssClass="user" Placeholder="dd/MM/yyyy"
                                AutoPostBack="true" OnTextChanged="txtKetThucTheoLuat_TextChanged"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtKetThucTheoLuat" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtKetThucTheoLuat" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtKetThucTheoLuat" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>

                    </tr>
                    <tr style="display:none">
                        <td>Thời hạn thực tế  </td>
                        <td>
                            <asp:TextBox ID="txtThangThucTe" runat="server" Width="50px" CssClass="user align_right" AutoPostBack="true"
                                onkeypress="return isNumber(event)" MaxLength="2" OnTextChanged="txtThangThucTe_TextChanged"></asp:TextBox>
                            Tháng
                            &nbsp;&nbsp;
                            <asp:TextBox ID="txtNgayThucTe" runat="server" Width="50px" CssClass="user align_right" AutoPostBack=" true"
                                Text="15"
                                onkeypress="return isNumber(event)" MaxLength="2" OnTextChanged="txtNgayThucTe_TextChanged"></asp:TextBox>
                            Ngày
                        </td>
                        <td>Hiệu lực đến ngày<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgayHieuLuc_DenNgay" runat="server" Width="250px" placeholder="dd/MM/yyyy" CssClass="user"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayHieuLuc_DenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Ghi chú</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtGhichu" runat="server" Width="640px" CssClass="user"></asp:TextBox>
                        </td>
                </table>
            </div>
        </div>
    </div>

        <div style="padding-top: 5px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClientClick="return ValidInputData();" OnClick="cmdUpdate_Click" />

            <asp:Button ID="cmdResert" runat="server" CssClass="buttoninput"
                Text="Làm mới" OnClick="cmdResert_Click" />
        </div>
        <div>
            <div style="padding-top: 5px; text-align: center; width: 95%">
                <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
            </div>
        </div>

        <asp:Panel runat="server" ID="pndata" Visible="false">
            <h4 class="tleboxchung">Danh sách</h4>
            <div class="boder" style="padding: 5px 10px;">
                <div style="padding-bottom: 10px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                </div>

                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">

                    <HeaderTemplate>
                        <table class="table2" width="100%" border="1">
                            <tr class="header">
                                <td style="width: 42px;">
                                    <div class="header_cell">TT</div>
                                </td>
                                <td style="width: 25%;">
                                    <div class="header_cell">Tòa án ủy thác</div>
                                </td>
                                <td style="width: 25%;">
                                    <div class="header_cell">Tòa án nhận ủy thác</div>
                                </td>
                                <td>
                                    <div class="header_cell">Quyết định thi hành án</div>
                                </td>
                                <td style="width: 70px;">
                                    <div class="header_cell">Thao tác</div>
                                </td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                         <asp:HiddenField ID="TRANGTHAI" runat="server" Value='<%# Eval("TRANGTHAI") %>' />             
                        <tr>
                            <td><%# Eval("STT")%></td>
                            <td><%# Eval("TenToaAnUyThac")%></td>
                            <td><%# Eval("TenToaAnNhanUyThac")%></td>
                            <td><b>- Mã QĐ:</b>  <%# Eval("MAQD") %><br />
                                <b>- Ngày QĐ/TB:</b>  <%# string.Format("{0:dd/MM/yyyy}", Eval("NGAYQD")) %><br />
                                <b>- Quyết định:</b>  <%# Eval("TENQD") %><br />
                                <b>- Người ký:</b>  <%# Eval("TenNguoiKy") %><br />
                            </td>
                            <td>
                                <div class="header_cell">
                                    <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                        CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                        Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>                                 
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
        </asp:Panel>    
    </asp:Panel>

        <div style="width: 100%; float: left;">

            <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
        </div>

    <!---------------------------------------------------------------->
    <script>
        function ValidInputData() {
            
        <%--    var txtMaQD = document.getElementById('<%=txtMaQD.ClientID%>');
            if (!Common_CheckTextBox(txtMaQD, "Mã quyết định"))
                return false;--%>

            var txtQDvaTB = document.getElementById('<%=txtQDvaTB.ClientID%>');
            if (!Common_CheckTextBox(txtQDvaTB, "mục Quyết định/ Thông báo"))
                return false;

            var hddToaAnUyThacID = document.getElementById('<%=hddToaAnUyThacID.ClientID%>');
            if (!Common_CheckEmpty(hddToaAnUyThacID.value)) {
                alert('Bạn chưa chọn Tòa án nhận ủy thác. Hãy kiểm tra lại!');
                hddToaAnUyThacID.focus();
                return false;
            }
            var txtSoQuyDinh = document.getElementById('<%=txtSoQuyDinh.ClientID%>');
            if (!Common_CheckTextBox(txtSoQuyDinh, "Số quyết định/ thông báo"))
                return false;

            var txtNgayRaQD = document.getElementById('<%=txtNgayRaQD.ClientID%>');
            if (!CheckDateTimeControl(txtNgayRaQD, 'Ngày ra quyết định hoặc thông báo'))
                return false;

            var txtHieuLuc_TuNgay = document.getElementById('<%=txtHieuLuc_TuNgay.ClientID%>');
            if (!CheckDateTimeControl(txtHieuLuc_TuNgay, 'mục "Hiệu lực từ ngày"'))
                return false;

           <%-- var txtKetThucTheoLuat = document.getElementById('<%=txtKetThucTheoLuat.ClientID%>');
            if (!CheckDateTimeControl(txtKetThucTheoLuat, 'Ngày kết thúc theo luật định'))
                return false;

            var txtNgayHieuLuc_DenNgay = document.getElementById('<%=txtNgayHieuLuc_DenNgay.ClientID%>');
            if (!CheckDateTimeControl(txtNgayHieuLuc_DenNgay, 'mục "Hiệu lực đến ngày"'))
                return false;--%>

            var ddlNguoiki = document.getElementById('<%=ddlNguoiki.ClientID%>');
            var value_change = ddlNguoiki.options[ddlNguoiki.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn người ký. Hãy kiểm tra lại!');
                ddlNguoiki.focus();
                return false;
            }
            return true;
        }
    </script>

    <script>
        function pageLoad(sender, args) {
            $(function () {

                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';
                $("[id$=txtToaAnUyThac]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAnUyThacID]").val(i.item.val); }, minLength: 1
                });
            });

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
