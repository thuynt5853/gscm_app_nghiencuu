<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="UyThacTHA.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.UyThacTHA.UyThacTHA" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>

    <!----------------------------------------------------->
    <asp:HiddenField ID="HddID" runat="server" Value="0" />
    <asp:HiddenField ID="Hddindex" runat="server" Value="1" />
    <asp:HiddenField ID="HddPage" runat="server" Value="20" />
     <asp:HiddenField ID="hddLoaiUyThac" runat="server" Value="0" />
    <!----------------------------------------------------->
    <asp:Panel ID="pn" runat="server">
        <div style="margin-left: 1%; width: 98%; float: left; margin-bottom : 200px;">
        <div style="margin: 15px 1%; text-align: center; width: 98%; color: red;">
            <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
        </div>
        <div class="boxchung">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
            <h4 class="tleboxchung bg_title_group bg_yellow">Ủy thác thi hành án</h4>
            <div class="boder" style="padding: 30px 10px;">
                <table class="table1">
                    <tr>
                        <td>Quyết định ủy thác THA<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="dropQuyetDinhUyThacTHA"
                                CssClass="chosen-select" Width="620px"
                                runat="server" AutoPostBack="true"
                                OnSelectedIndexChanged="dropQuyetDinhUyThacTHA_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Tòa án ủy thác<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtUy_thac" Width="222px" runat="server" Enabled="false" CssClass="user"></asp:TextBox>
                        </td>
                        <td>Tòa án nhận ủy thác <span class="batbuoc">(*)</span>&nbsp;                           
                        </td>
                        <td>
                            <asp:TextBox ID="txtToaAnUyThac" CssClass="user" Enabled="false"
                                runat="server" Width="222px"></asp:TextBox></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Số QĐ/TB<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtQD_SoQD" runat="server" Width="222px"
                                Enabled="false" CssClass="user"></asp:TextBox></td>
                        <td>Ngày ra QĐ/TB<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtQD_NgayQD" runat="server" Width="222px" Enabled="false"
                                CssClass="user" placeholder="dd/MM/yyyy"></asp:TextBox>
                        </td>
                        <td></td>
                    </tr>
                    <!---------------------------------------------->
                  <%--  <tr style="display:none">
                        <td style="width: 100px;">Trường hợp ủy thác
                        </td>
                        <td style="width: 250px;">
                            <asp:RadioButtonList ID="rdTruongHopUT" runat="server"
                                RepeatDirection="Horizontal"
                                AutoPostBack="true" OnSelectedIndexChanged="rdTruongHopUT_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="0">Lý do</asp:ListItem>
                                <asp:ListItem Value="1">Khác</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <asp:Panel ID="pnLyDo" runat="server">
                            <td>Lý do</td>
                            <td>
                                <asp:DropDownList ID="dropLyDo" runat="server"
                                    CssClass="chosen-select" Width="230px">
                                </asp:DropDownList>
                            </td>
                        </asp:Panel>
                        <asp:Panel ID="pnKhac" runat="server" Visible="false">
                            <td></td>
                            <td></td>
                        </asp:Panel>
                    </tr>--%>
                    <tr>
                        <td style="width: 100px;">Trường hợp ủy thác
                        </td>
                        <td style="width: 350px;">
                            <asp:RadioButtonList ID="rdTHUyThac" runat="server"
                                RepeatDirection="Horizontal"
                                AutoPostBack="true" OnSelectedIndexChanged="rdTHUyThac_SelectedIndexChanged" >
                                <asp:ListItem Selected="True" Value="0">Ủy thác vì không thuộc thẩm quyền</asp:ListItem>
                                <asp:ListItem Value="1">Khác</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <asp:HiddenField ID="hddLyDoKhacID" runat="server" />
                        <asp:Panel ID="pnLyDoKhac" runat="server" Visible="false">
                            <td>Khác</td>
                            <td>
                                <asp:TextBox ID="txtLydoKhac" MaxLength="2000" runat="server" CssClass="user"
                                    Width="222px" > 
                                </asp:TextBox>
                                           <%-- <a alt="Nhập tên để chọn Lý do ủy thác" class="tooltipright">
                                                <asp:TextBox ID="txtLydoKhac" CssClass="user"
                                                    runat="server" Width="222px" MaxLength="250" AutoCompleteType="Search"></asp:TextBox></a>--%>
                            </td>
                               
                        </asp:Panel>                    
                    </tr>
                    <tr>
                        <td style="width: 120px">Ngày ủy thác<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNgayUyThac" runat="server" Width="222px"
                                CssClass="user"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayUyThac" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayUyThac" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayUyThac" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                        <td style="width: 120px">Ngày nhận</td>
                        <td>
                            <asp:TextBox ID="txtNgayNhan" runat="server" Width="222px" Enabled="true"
                                CssClass="user"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayNhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Người nhập<span class="batbuoc">(*)</span> </td>
                        <td>
                            <asp:DropDownList ID="dropNguoiNhap" runat="server"
                                CssClass="chosen-select" Width="230px">
                            </asp:DropDownList>
                        </td>
                        <td>Người ký <span class="batbuoc">(*)</span> </td>
                        <td>
                            <asp:DropDownList ID="DropNguoiKi" runat="server" Enabled="true"
                                CssClass="chosen-select" Width="230px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Ghi chú</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtGhichu" runat="server" 
                                Width="611px" CssClass="user"></asp:TextBox>
                        </td>
                    </tr>

                            <tr>
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete" OnClientUploadComplete="onUploadComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF"/>
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                    <asp:Label ID="lblFileName" runat="server" ForeColor="#0e7eee"></asp:Label>
                                </td>
                            </tr>
                    <tr>
                        <td colspan="4" style="padding-top: 10px; text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                            <asp:Button ID="cmdResert" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="cmdResert_Click" /></td>
                    </tr>
                </table>
                <div style="padding-top: 10px; text-align: center; width: 95%; float: left; margin-left: 2%;color:red; font-weight:bold;">
                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                </div>

            </div>
        </div>
        <asp:Panel runat="server" ID="pndata" Visible="false">
            <div style="float: left; width: 100%;">
                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table2" style="width: 100%" border="1">
                            <tr class="header">
                                <td style="width: 42px;">
                                    <div class="header_cell">TT</div>
                                </td>
                                <td>
                                    <div class="header_cell">Quyết định thi hành án</div>
                                </td>
                                <td>
                                    <div class="header_cell">Trường hợp ủy thác</div>
                                </td>
                                <%--<td>
                                    <div class="header_cell">Lý do</div>
                                </td>--%>
                                <td style="width: 85px;">
                                    <div class="header_cell">Ngày ủy thác</div>
                                </td>
                                <td style="width: 100px; text-align: center;">
                                    <div class="header_cell">Người nhập</div>
                                </td>
                                <td style="width: 70px; text-align: center;">
                                    <div class="header_cell">File đính kèm</div>
                                </td>
                                <td style="width: 70px; text-align: center;">
                                    <div class="header_cell">Thao tác</div>
                                </td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:HiddenField ID="TRANGTHAI" runat="server" Value='<%# Eval("TRANGTHAI") %>' />
                        <tr>
                            <td><%# Eval("STT")%></td>
                            <td><b>- Mã QĐ:</b>  <%# Eval("MAQD") %><br />
                                <b>- Quyết định:</b>  <%# Eval("TENQD") %><br />
                                <b><%# Eval("TRANGTHAIBIAN") %></b><br />
                            </td>
                            <td><%# Eval("TRuongHopUyThac")%></td>
                            <%--<td><%# Eval("TenLyDo")%></td>--%>
                            <td><%# string.Format("{0:dd/MM/yyyy}", Eval("NgayUyThac")) %><br />
                            </td>
                            <td style="text-align: center;"><%# Eval("TenNguoiNhap") %></td>
                            <td style="text-align: center;">
                                            <ItemTemplate >
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") %>'/>
                                            </ItemTemplate>
                            </td>
                            <td style="text-align: center;">
                                <div class="header_cell">
                                    <asp:LinkButton ID="lbtSua" runat="server"  CausesValidation="false"
                                        Text="Sửa" ForeColor="#0e7eee"
                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
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
    </div>
    </asp:Panel>

        <div style="width: 100%; float: left;">

            <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
        </div>
    <script>
        function validate()
        {
            var value_changed = "";
            var dropQuyetDinhUyThacTHA = document.getElementById('<%=dropQuyetDinhUyThacTHA.ClientID%>');
            value_changed = dropQuyetDinhUyThacTHA.options[dropQuyetDinhUyThacTHA.selectedIndex].value;
            if (value_changed == "0") {
                alert('Bạn chưa chọn Quyết định ủy thác thi hành án. Hãy kiểm tra lại!');
                dropQuyetDinhUyThacTHA.focus();
                return false;
            }
            //-------------------------
           <%-- var hddLoaiUyThac = document.getElementById('<%=hddLoaiUyThac.ClientID%>');
            if (hddLoaiUyThac.value == "0") {
                var dropLyDo = document.getElementById('<%=dropLyDo.ClientID%>');
                value_changed = dropLyDo.options[dropLyDo.selectedIndex].value;
                if (value_changed == "0") {
                    alert('Bạn chưa chọn lý đo. Hãy kiểm tra lại!');
                    dropLyDo.focus();
                    return false;
                }
            }--%>
            var rdTHUyThac = document.getElementById('<%=rdTHUyThac.ClientID%>');
            if (rdTHUyThac.value == "1") {
                var hddLyDoKhacID = document.getElementById('<%=hddLyDoKhacID.ClientID%>');
                if (!Common_CheckEmpty(hddLyDoKhacID.value)) {
                    alert('Bạn chưa nhập Lý do ủy thác. Hãy kiểm tra lại!');
                    hddLyDoKhacID.focus();
                    return false;
                }
            }
           // --------------------------------

            var txtNgayUyThac = document.getElementById('<%=txtNgayUyThac.ClientID%>')
            if (!CheckDateTimeControl(txtNgayUyThac, 'Ngày ủy thác'))
                return false;
            //----------
            var txtNgayNhan = document.getElementById('<%=txtNgayNhan.ClientID%>')
            if (Common_CheckEmpty(txtNgayNhan.value)) {
                if (!CheckDateTimeControl(txtNgayNhan, 'Ngày nhận'))
                    return false;

                if (!SoSanhDate(txtNgayNhan, txtNgayUyThac)) {
                    alert('Xin vui lòng kiểm tra lại. "Ngày nhận" không thể nhỏ hơn "Ngày ủy thác" !');
                    txtNgayNhan.focus();
                    return false;
                }
            }
            //---------------------------------           
            var dropNguoiNhap = document.getElementById('<%=dropNguoiNhap.ClientID%>');
            var value_change = dropNguoiNhap.options[dropNguoiNhap.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn người nhập. Hãy kiểm tra lại!');
                dropNguoiNhap.focus();
                return false;
            }

            var txtGhichu = document.getElementById('<%=txtGhichu.ClientID%>')
            if (Common_CheckEmpty(txtGhichu.value)) {
                var soluongkytu = 2000;
                length_value = txtGhichu.value.length;
                if (length_value > soluongkytu) {
                    alert("Mục 'Ghi chú' không thể nhập quá " + soluong + " ký tự. Hãy kiểm tra lại!");
                    txtGhichu.focus();
                    return false;
                }
            }
            return true;
        }
    </script>

    <script type="text/javascript">
        function onUploadComplete(sender, args) {
            var lbl = document.getElementById('<%=lblFileName.ClientID%>');
            if (lbl && args && typeof args.get_fileName === 'function') {
                lbl.textContent = args.get_fileName();
            }
        }
    </script>

    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

    <%--<script>
            function pageLoad(sender, args) {
                $(function () {

                    var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchLyDoUyThac") %>';
                    $("[id$=txtLydoKhac]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                        select: function (e, i) {
                            $("[id$=hddLyDoKhacID]").val(i.item.val);
                            console.log(i.item.val);
                        }, minLength: 1
                });
                });
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
        }      
    </script>--%>
</asp:Content>

