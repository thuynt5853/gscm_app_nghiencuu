<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongTinVA_File_delete.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.ThongTinVA_File_delete" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/THA/Hoso/uDSBiCan.ascx" TagPrefix="uc1" TagName="uDSBiCan" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCaoID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddCaoTrangID" runat="server" Value="0" />
    <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
    <!------------------------------------------->
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiAnID" runat="server" Value="0" />
    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
        }

        .button_right {
            float: right;
            text-align: center;
            margin-left: 10px;
        }
    </style>
    <div id="divBackground" style="position: absolute; top: 0px; left: 0px; background-color: black; z-index: 100; opacity: 0.8; filter: alpha(opacity=60); -moz-opacity: 0.8; overflow: hidden; display: none">
    </div>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClick="cmdUpdateVuAn_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClientClick="return validate_all();"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div>
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 80px;">Loại</td>
                                    <td style="width: 180px;">
                                        <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select"
                                            Width="157px"
                                            runat="server">
                                        </asp:DropDownList></td>


                                    <%--<td style="width: 150px;">Xác nhận được ủy thác</td>--%>
                                    <td>
                                        <asp:Label ID="checkuyquyen" runat="server" Visible="false">
                                            <asp:CheckBox ID="CheckBoxUyQuyen" runat="server" Font-Bold="true" Text="" Width="260px" onchange="UyQuyen(this)" /></asp:Label>
                                    </td>
                                    <td style="width: 90px;"><span class="batbuoc"></span></td>
                                    <td>
                                        <asp:TextBox ID="TextBox1" CssClass="user"
                                            runat="server" Width="260px" Visible="false"></asp:TextBox></td>
                                    <%--<td style="width: 90px;">Mã vụ án<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtMaVuAn" CssClass="user"
                                        runat="server" Width="260px"></asp:TextBox></td>--%>
                                </tr>
                                <tr>
                                    <td>Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">

                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh"
                                            TextMode="MultiLine" Rows="2"
                                            runat="server" Width="514px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td style="width: 120px">Ngày xảy ra vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayXayra" runat="server" CssClass="user"
                                            Width="150px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayXayra" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayXayra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Tính chất bản án</td>
                                    <td>
                                        <asp:DropDownList ID="dropTinhChatVuAn" CssClass="chosen-select"
                                            runat="server" Width="160px">
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Giai đoạn xét xử</td>
                                    <td>
                                        <asp:DropDownList ID="ddlGDXX" CssClass="chosen-select"
                                            runat="server" Width="157px" AutoPostBack="true" OnSelectedIndexChanged="ddlGDXX_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Phúc thẩm"></asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNgayBanAn" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user"
                                            Width="150px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                            TargetControlID="txtNgayBanAn" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                            TargetControlID="txtNgayBanAn" Mask="99/99/9999"
                                            MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 170px;">
                                        <asp:Label ID="lbSoBanAn" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanAn" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="150px" MaxLength="50"></asp:TextBox>

                                    </td>

                                </tr>
                                <tr>
                                    <%--<td>
                                        <asp:Label ID="lbNgaycohieuluc" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayAnCoHieuLuc" runat="server" CssClass="user"
                                            Width="150px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                            TargetControlID="txtNgayAnCoHieuLuc" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                            TargetControlID="txtNgayAnCoHieuLuc" Mask="99/99/9999"
                                            MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>--%>
                                    <td>
                                        <asp:Label ID="lbToaAn" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:HiddenField ID="hddToaAnID" runat="server" />
                                        <a alt="Nhập tên để chọn Tòa án ra bản án" class="tooltipright">
                                            <asp:TextBox ID="txtToaAn" CssClass="user"
                                                runat="server" Width="150px" MaxLength="250"></asp:TextBox></a>
                                    </td>

                                </tr>

                                <asp:Panel ID="pnGDXX" runat="server">
                                    <tr>
                                        <td>Ngày bản án sơ thẩm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBAST" runat="server" CssClass="user"
                                                Width="150px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server"
                                                TargetControlID="txtNgayBAST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                                TargetControlID="txtNgayBAST" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Số bản án sơ thẩm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoBAST" runat="server" CssClass="user align_right"
                                                Width="150px" MaxLength="10"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr>
                                        <%--<td>Ngày hiệu lực bản án sơ thẩm<span class="batbuoc">(*)</span>

                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayAnCoHieuLucST" runat="server" CssClass="user"
                                                Width="150px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                TargetControlID="txtNgayAnCoHieuLucST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                                TargetControlID="txtNgayAnCoHieuLucST" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>--%>
                                        <td>Tòa án ra bản án sơ thẩm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:HiddenField ID="hddToaAnIDST" runat="server" />
                                            <a alt="Nhập tên để chọn Tòa án ra bản án" class="tooltipright">
                                                <asp:TextBox ID="txtToaAnST" CssClass="user"
                                                    runat="server" Width="150px" MaxLength="250"></asp:TextBox></a>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>

                        </div>
                    </div>

                    <!-------------------------------->
                    <asp:Panel ID="pnToiDanhChung" runat="server" Visible="false">
                        <div class="boxchung">
                            <h4 class="tleboxchung bg_title_group">Tội danh áp dụng cho các bị can</h4>
                            <div class="boder" style="padding: 5px 10px;">
                                <asp:Repeater ID="rptToiDanh" runat="server"
                                    OnItemDataBound="rptToiDanh_ItemDataBound" OnItemCommand="rptToiDanh_ItemCommand">
                                    <HeaderTemplate>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>STT</strong></div>
                                                </td>
                                                <td width="150px">
                                                    <div align="center"><strong>Bộ luật</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Điều</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Khoản</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Điểm</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Tội danh</strong></div>
                                                </td>
                                                <td width="60px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 100%; text-align: center;">
                                                    <%#Eval("STT") %>
                                                </div>
                                            </td>
                                            <td><%# Eval("TenBoLuat") %></td>
                                            <td><%# Eval("Dieu") %></td>
                                            <td><%# Eval("Khoan") %></td>
                                            <td><%# Eval("Diem") %></td>
                                            <td>
                                                <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID") %>' />

                                                <asp:HiddenField ID="hddToiDanhID" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                                <asp:HiddenField ID="hddArrSapXep" runat="server" Value='<%#Eval("ArrSapXep") %>' />
                                                <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                                <asp:HiddenField ID="hddBoLuatID" runat="server" Value='<%#Eval("DieuLuatID") %>' />
                                                <asp:HiddenField ID="hddLoaiToiPham" runat="server" Value='<%#Eval("LoaiToiPham") %>' />

                                                <asp:TextBox ID="txtTenToiDanh" CssClass="user" Width="98%"
                                                    Font-Bold="true" runat="server" Text='<%#Eval("TENTOIDANH") %>'
                                                    Visible='<%# Convert.ToInt16( Eval("IsEdit")+"")==1?true:false  %>'></asp:TextBox>
                                                <div style='display: <%# Convert.ToInt16( Eval("IsEdit")+"")==1? "none":"block"  %>'>
                                                    <%#Eval("TENTOIDANH") %>
                                                </div>
                                            </td>
                                            <td>
                                                <div align="center">
                                                    <asp:LinkButton ID="lkXoa" runat="server"
                                                        Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"
                                                        CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="xoa"></asp:LinkButton>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>


                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách bị can</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemBiCao" runat="server"
                                OnClick="lkThemBiCao_Click" OnClientClick="return validate();"
                                CssClass="buttonpopup them_user">Thêm bị can</asp:LinkButton>
                            <uc1:uDSBiCan runat="server" ID="uDSBiCan" />
                        </div>
                    </div>

                    <!-------------------------------->
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                    </div>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 100px;">
                    <asp:Button ID="cmdUpdateVuAnB" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClientClick="return validate_all();" OnClick="cmdUpdateVuAn_Click" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
            </div>
        </div>
    </div>
    <div style="display: none">
        <asp:Button ID="cmdLoadDsBiDonKhac" runat="server"
            Text="Load ds BI don khac" OnClick="cmdLoadDsBiDonKhac_Click" />
    </div>
    <script>
        function LoadDsBiCan() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
        }
    </script>
    <script>
<%--        function LoadDsBiCan() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
        }--%>


        var CheckBoxUyQuyen_boolean = false;
        function UyQuyen(val) {
            var CheckBoxUyQuyen = document.getElementById('<%=CheckBoxUyQuyen.ClientID%>');
            CheckBoxUyQuyen_boolean = CheckBoxUyQuyen.checked
        }

    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
            $("[id$=txtTamtru]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddTamtruID]").val(i.item.val); }, minLength: 1
            });
            //----------------
            $("[id$=txtHKTT]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddHKTTID]").val(i.item.val); }, minLength: 1
            });
            //-----------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }


            var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMToaAn") %>';
            $("[id$=txtToaAn]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldm_toaan, data: "{ 'q': '" + request.term + "' , 'checkUyQuyen': '" + CheckBoxUyQuyen_boolean + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddToaAnID]").val(i.item.val); }, minLength: 1
            });
            $("[id$=txtToaAnST]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldm_toaan, data: "{ 'q': '" + request.term + "' , 'checkUyQuyen': '" + CheckBoxUyQuyen_boolean + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddToaAnIDST]").val(i.item.val); }, minLength: 1
            });


            //-----------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


    <script>
        function validate() {

            if (!Validate_VuAn())
                return false;

            return true;
        }
        function validate_all() {
            if (!Validate_VuAn())
                return false;
            return true;
        }

        function Validate_VuAn() {
<%--            var txtMaVuAn = document.getElementById('<%=txtMaVuAn.ClientID%>');
            if (!Common_CheckTextBox(txtMaVuAn,"mã vụ án"))
                return false;--%>

            var txtTenVuAn = document.getElementById('<%=txtTenVuAn.ClientID%>');
            if (!Common_CheckTextBox(txtTenVuAn, "tên vụ án"))
                return false;

            //-------------------------------------------
            <%--var txtNgayXayra = document.getElementById('<%=txtNgayXayra.ClientID%>');
            if (!CheckDateTimeControl(txtNgayXayra, 'Ngày xảy ra vụ án'))
                return false;--%>

            var txtNgayBanAn = document.getElementById('<%=txtNgayBanAn.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanAn, 'Ngày bản án'))
                return false;

            var txtSoBanAn = document.getElementById('<%=txtSoBanAn.ClientID%>');
            if (!Common_CheckTextBox(txtSoBanAn, 'Số bản án'))
                return false;

            //if (!SoSanhDate(txtNgayBanAn, txtNgayXayra)) {
            //    alert('Xin vui lòng kiểm tra lại. "Ngày bản án" không thể nhỏ hơn "Ngày xảy ra vụ án" !');
            //    txtNgayBanAn.focus();
            //    return false;
            //}
            //----------------------
            <%--var txtNgayAnCoHieuLuc = document.getElementById('<%=txtNgayAnCoHieuLuc.ClientID%>');
            if (!CheckDateTimeControl(txtNgayAnCoHieuLuc, 'Ngày bản án có hiệu lực'))
                return false;--%>
            //if (!SoSanhDate(txtNgayAnCoHieuLuc, txtNgayXayra)) {
            //    alert('Xin vui lòng kiểm tra lại. "Ngày bản án có hiệu lực" không thể nhỏ hơn "Ngày xảy ra vụ án" !');
            //    txtNgayAnCoHieuLuc.focus();
            //    return false;
            //}
            //if (!SoSanhDate(txtNgayAnCoHieuLuc, txtNgayBanAn)) {
            //    alert('Xin vui lòng kiểm tra lại. "Ngày bản án có hiệu lực" không thể nhỏ hơn "Ngày bản án" !');
            //    txtNgayAnCoHieuLuc.focus();
            //    return false;
            //}

            //-------------------------------------------
            var hddToaAn = document.getElementById('<%=hddToaAnID.ClientID%>');
            var txtToaAn = document.getElementById('<%=txtToaAn.ClientID%>');
            if (!Common_CheckEmpty(hddToaAn.value)) {
                alert('Bạn chưa chọn tòa án ra bản án. Hãy kiểm tra lại!');
                txtToaAn.focus();
                return false;
            }
            var txtNgayBAST = document.getElementById('<%=txtNgayBAST.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBAST, 'Ngày bản án sơ thẩm'))
                return false;

            var txtSoBAST = document.getElementById('<%=txtSoBAST.ClientID%>');
            if (!Common_CheckTextBox(txtSoBAST, 'Số bản án sơ thẩm'))
                return false;

            <%--var txtNgayAnCoHieuLucST = document.getElementById('<%=txtNgayAnCoHieuLucST.ClientID%>');
            if (!CheckDateTimeControl(txtNgayAnCoHieuLucST, 'Ngày bản án sơ thẩm có hiệu lực'))
                return false;--%>

            if (!SoSanhDate(txtNgayAnCoHieuLucST, txtNgayBAST)) {
                alert('Xin vui lòng kiểm tra lại. "Ngày bản án sơ thẩm có hiệu lực" không thể nhỏ hơn "Ngày bản án sơ thẩm" !');
                txtNgayAnCoHieuLucST.focus();
                return false;
            }

            var hddToaAnST = document.getElementById('<%=hddToaAnIDST.ClientID%>');
            var txtToaAnST = document.getElementById('<%=txtToaAnST.ClientID%>');
            if (!Common_CheckEmpty(hddToaAnST.value)) {
                alert('Bạn chưa chọn tòa án sơ thẩm ra bản án. Hãy kiểm tra lại!');
                txtToaAnST.focus();
                return false;
            }
            //-------------------------------------------
            return true;
        }

        function popup_them_bc(VuAnID) {
            var link = "/QLAN/THA/Hoso/DanhsachBiCan.aspx?hsID=" + VuAnID;
            var width = 800;
            var height = 900;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
            LoadModalDiv();
        }

        function LoadModalDiv() {

            var bcgDiv = document.getElementById("divBackground");

            bcgDiv.style.display = "block";

            if (bcgDiv != null) {

                if (document.body.clientHeight > document.body.scrollHeight) {

                    bcgDiv.style.height = document.body.clientHeight + "px";

                }

                else {

                    bcgDiv.style.height = document.body.scrollHeight + "px";

                }

                bcgDiv.style.width = "100%";

            }

        }

        function HideModalDiv() {

            var bcgDiv = document.getElementById("divBackground");

            bcgDiv.style.display = "none";

        }

        function popupCaoTrang() {
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pCaoTrang.aspx?hsID=" + hddVuAnID.value
            var width = 950;
            var height = 550;
            PopupCenter(link, "Cáo trạng", width, height);
        }
        function popupDieuLuatAD() {
            var width = 950;
            var height = 550;
            var hddCaoTrangID = document.getElementById('<%=hddCaoTrangID.ClientID%>');
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var hddBiCaoID = document.getElementById('<%=hddBiCaoID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pChonToiDanh.aspx?hsID=" + hddVuAnID.value + "&bID=" + hddBiCaoID.value;
            PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
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
