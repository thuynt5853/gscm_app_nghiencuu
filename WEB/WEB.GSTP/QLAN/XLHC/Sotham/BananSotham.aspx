<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BananSotham.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Sotham.BananSotham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddNgayPCTPGQD" Value="" runat="server" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddIsShowLydoDinhchi" runat="server" Value="0" />
    <style>
        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }
        
        .dropdown-td .chosen-container {
            min-height: 32px;
        }
       
        .dropdown-td .chosen-drop {
            z-index: 9999 !important; /* đảm bảo hiển thị */
        }
        
        .dropdown-td .chosen-container-single .chosen-single {
            height: auto;
            line-height: normal;
            padding: 6px 12px;
            white-space: normal; /* nếu chữ dài */
        }
        
        .dropdown-td .chosen-container .chosen-results {
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
    <div class="boxchung">
        <h4 class="tleboxchung">I. THÔNG TIN KẾT QUẢ GIẢI QUYẾT</h4>
        <div class="boder" style="padding: 10px;">
            <table class="table1">
                <tr style="display: none;">
                    <td>Loại quyết định<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlLoaiQD" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQD_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr class="dropdown-td">
                    <td>Kết quả giải quyết<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Số quyết định<span class="batbuoc">(*)</span></td>
                    <td>
                        <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                    </td>
                    <td>Ngày mở phiên họp</td>
                    <td>
                        <asp:TextBox ID="txtNgaymophientoa" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaymophientoa" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaymophientoa" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 167px;">Ngày quyết định<span class="batbuoc">(*)</span></td>
                    <td style="width: 135px;">
                        <asp:TextBox ID="txtNgaytuyenan" runat="server" CssClass="user" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtNgaytuyenan_TextChanged"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytuyenan" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytuyenan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender1" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>
                    <td style="width: 165px;">Ngày hiệu lực</td>
                    <td>
                        <asp:TextBox ID="txtNgayhieuluc" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayhieuluc" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender3" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayhieuluc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender2" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>
                </tr>
                <tr id="rowLydodinhchi" runat="server">
                    <td style="width: 167px;">Lý do<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:TextBox ID="txtLydodinhchi" runat="server" CssClass="user" Width="650px" MaxLength="200"></asp:TextBox>
                    </td>
                </tr>
                <tr style="display: none;">
                    <td>Biện pháp đề nghị áp dụng<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="412px"></asp:DropDownList>
                    </td>

                </tr>
                <tr style="display: none;">
                    <td>Kết quả giải quyết?</td>
                    <td colspan="3">
                        <asp:RadioButtonList ID="rdbChapnhanYC" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbChapnhanYC_SelectedIndexChanged">
                            <asp:ListItem Value="1" Text="Áp dụng biện pháp xử lý hành chính" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="0" Text="Không áp dụng biện pháp xử lý hành chính"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>

                </tr>
                <tr>
                    <td>
                        <div id="div_ThoiGianApDung" runat="server" visible="true">
                            Thời hạn áp dụng<span class="batbuoc">(*)</span>
                        </div>
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtThoihan" CssClass="user align_right"
                            runat="server" Width="100px" onkeypress="return isNumber(event)"></asp:TextBox><asp:Label ID="lblThoihanbb" runat="server" Text="(tháng)"></asp:Label>
                    </td>

                </tr>
                <tr>
                    <td>Vụ việc quá hạn luật định ?<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:RadioButtonList ID="rdVuAnQuaHan" AutoPostBack="true"
                            runat="server" RepeatDirection="Horizontal"
                            OnSelectedIndexChanged="rdVuAnQuaHan_SelectedIndexChanged">
                            <asp:ListItem Value="0">Không</asp:ListItem>
                            <asp:ListItem Value="1">Có</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>

                </tr>
                <asp:Panel ID="pnNguyenNhanQuaHan" runat="server" Visible="false">
                    <tr>
                        <td>Nguyên nhân chủ quan ?<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:RadioButtonList ID="rdNNChuQuan" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Không</asp:ListItem>
                                <asp:ListItem Value="1">Có</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td>Nguyên nhân khách quan ?<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:RadioButtonList ID="rdNNKhachQuan" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Không</asp:ListItem>
                                <asp:ListItem Value="1">Có</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </asp:Panel>
                <tr>
                    <td>Tệp đính kèm</td>
                    <td colspan="3">
                        <asp:HiddenField ID="hddFilePath" runat="server" />

                        <asp:CheckBox ID="chkKySo" Checked="False" runat="server" AutoPostBack="True" OnCheckedChanged="cmd_load_form_Click" Text="Sử dụng ký số file đính kèm" />
                        <br />
                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                        <asp:HiddenField ID="hddSessionID" runat="server" />
                        <asp:HiddenField ID="hddURLKS" runat="server" />
                        
                        <div id="zonekyso" runat="server" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                            </ul>
                        </div>
                        <div id="zonekythuong" runat="server" style="margin-top: 10px; width: 80%;">
                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                OnClientUploadComplete="UploadGrid" ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                        </div>
                        <div style="display: none">
                            <asp:Button ID="cmdThemFileTL" runat="server"
                                Text="Them tai lieu" OnClick="cmdThemFileTL_Click" />
                            <asp:Button ID="cmd_load_form" runat="server"
                                Text="Lưu File" CausesValidation="false" OnClick="cmd_load_form_Click" />
                            <script>
                                function UploadGrid(sender) {
                                    $("#<%= cmd_load_form.ClientID %>").click();
                                }
                            </script>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="3">
                        <asp:DataGrid ID="dgFile" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgFile_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                            <Columns>
                                <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        TT
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Container.DataSetIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Tên tệp
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TENFILE") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                    <HeaderTemplate>
                                        Tệp đính kèm
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text="Xem" CausesValidation="false" CommandName="Download" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa file" ForeColor="#0e7eee"
                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa file này? ');"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                 <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                            </Columns>
                            <HeaderStyle CssClass="header"></HeaderStyle>
                            <ItemStyle CssClass="chan"></ItemStyle>
                            <PagerStyle Visible="false"></PagerStyle>
                        </asp:DataGrid>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:Label ID="lstErr" runat="server" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="center">
                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu thông tin" OnClick="btnUpdate_Click" OnClientClick="return Validate();" />
                        <asp:Button ID="cmdHuyThongTin" runat="server" CssClass="buttoninput"
                            Text="Xóa thông tin" OnClick="cmdHuyThongTin_Click"
                            OnClientClick="return confirm('Bạn thực sự muốn xóa thông tin này? ');" />

                        <%--<asp:Button ID="btnTest" runat="server" CssClass="buttoninput"
                            Text="Test" OnClick="btnTest_Click" />--%>
                    </td>
                </tr>
            </table>
        </div>
    </div>
     <div style="height: 200px"></div>

    <script type="text/javascript">
        function uploadComplete(sender) {
            __doPostBack('tctl00$UpdatePanel1', '');
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
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>

    <script type="text/javascript">
        var count_file = 0;
        <%--function CheckKyso() {
            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');

            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }
        }--%>
        function VerifyPDFCallBack(rv) {

        }

        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;

            var json_prms = JSON.stringify(prms);

            vgca_verify_pdf(json_prms, VerifyPDFCallBack);
        }

        function SignFileCallBack1(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                var new_item = document.createElement("li");
                new_item.innerHTML = received_msg.FileName;
                hddFilePath.value = received_msg.FileServer;
                //-------------Them icon xoa file------------------
                var del_item = document.createElement("img");
                del_item.src = '/UI/img/xoa.gif';
                del_item.style.width = "15px";
                del_item.style.margin = "5px 0 0 5px";
                del_item.onclick = function () {
                    if (!confirm('Bạn muốn xóa file này?')) return false;
                    document.getElementById("file_name").removeChild(new_item);
                }
                del_item.style.cursor = 'pointer';
                new_item.appendChild(del_item);

                document.getElementById("file_name").appendChild(new_item);
                 $("#<%= cmdThemFileTL.ClientID %>").click();
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }

        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
            var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }

    </script>
    <script type="text/javascript">
        function Validate() {
            var txtSobanan = document.getElementById('<%=txtSobanan.ClientID%>');
            if (txtSobanan.value.trim().length == 0) {
                alert('Bạn chưa nhập số quyết định');
                txtSobanan.focus();
                return false;
            }
            //-----------------------------------
            var hddNgayPCTPGQD = document.getElementById('<%=hddNgayPCTPGQD.ClientID%>');
            var txtNgaymophientoa = document.getElementById('<%=txtNgaymophientoa.ClientID%>');
            var ngay_mo_pt = txtNgaymophientoa.value;
            if (ngay_mo_pt != "") {
                if (!CheckDateTimeControl(txtNgaymophientoa, "Ngày mở phiên họp"))
                    return false;
                if (hddNgayPCTPGQD.value != "") {
                    if (!SoSanh2Date(txtNgaymophientoa, 'Ngày mở phiên họp', hddNgayPCTPGQD.value, 'Ngày phân công thẩm phán giải quyết đơn (' + hddNgayPCTPGQD.value + ')'))
                        return false;
                }
            }
            //---------------------------------------
            var txtNgaytuyenan = document.getElementById('<%=txtNgaytuyenan.ClientID%>');
            if (!CheckDateTimeControl(txtNgaytuyenan, "Ngày quyết định"))
                return false;
            if (hddNgayPCTPGQD.value != "") {
                if (!SoSanh2Date(txtNgaytuyenan, 'Ngày quyết định', hddNgayPCTPGQD.value, 'Ngày phân công thẩm phán giải quyết đơn (' + hddNgayPCTPGQD.value + ')'))
                    return false;
            }
            if (ngay_mo_pt != "") {
                if (!SoSanh2Date(txtNgaytuyenan, 'Ngày quyết định', ngay_mo_pt, 'Ngày mở phiên họp'))
                    return false;
            }
            //---------------------------------------
            var txtNgayhieuluc = document.getElementById('<%=txtNgayhieuluc.ClientID%>');
            if (Common_CheckEmpty(txtNgayhieuluc.value)) {
                if (!Common_IsTrueDate(txtNgayhieuluc.value)) {
                    txtNgayhieuluc.focus();
                    return false;
                }
                if (!SoSanh2Date(txtNgayhieuluc, 'Ngày hiệu lực', txtNgaytuyenan.value, 'Ngày quyết định'))
                    return false;
            }
            //-----------------------------------
            var rdbChapnhanYC = document.getElementById('<%=rdbChapnhanYC.ClientID%>');
            var rdbChapnhanYC_Inputs = rdbChapnhanYC.getElementsByTagName('input');
            var rdbChapnhanYC_Selected = 0;
            for (var i = 0; i < rdbChapnhanYC_Inputs.length; i++) {
                if (rdbChapnhanYC_Inputs[i].checked) {
                    rdbChapnhanYC_Selected = rdbChapnhanYC_Inputs[i].value;
                    break;
                }
            }
            if (rdbChapnhanYC_Selected == 1) {
                var txtThoihan = document.getElementById('<%=txtThoihan.ClientID%>');
                if (txtThoihan.value == "") {
                    alert('Chưa nhập thời hạn áp dụng.');
                    txtThoihan.focus();
                    return false;
                }
            }
            var rdVuAnQuaHan = document.getElementById('<%=rdVuAnQuaHan.ClientID%>');
            msg = 'Bạn chưa chọn vụ án quá hạn luật định. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdVuAnQuaHan, msg))
                return false;
            //---------------
            var rdVuAnQuaHan_Inputs = rdVuAnQuaHan.getElementsByTagName('input');
            var rdVuAnQuaHan_Selected = 0;
            for (var i = 0; i < rdVuAnQuaHan_Inputs.length; i++) {
                if (rdVuAnQuaHan_Inputs[i].checked) {
                    rdVuAnQuaHan_Selected = rdVuAnQuaHan_Inputs[i].value;
                    break;
                }
            }
            if (rdVuAnQuaHan_Selected == 1) {
                var rdNNChuQuan = document.getElementById('<%=rdNNChuQuan.ClientID%>');
                msg = 'Bạn chưa chọn nguyên nhân chủ quan. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdNNChuQuan, msg))
                    return false;
                var rdNNKhachQuan = document.getElementById('<%=rdNNKhachQuan.ClientID%>');
                msg = 'Bạn chưa chọn nguyên nhân khách quan. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdNNKhachQuan, msg))
                    return false;
            }
            return true;
        }
    </script>
</asp:Content>

