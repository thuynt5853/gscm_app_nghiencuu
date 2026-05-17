<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Bananphuctham.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Phuctham.Bananphuctham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <style>
        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }
        .chosen-450px {
    width: 450px !important;
}

    </style>
    <div class="boxchung">
        <h4 class="tleboxchung">I. THÔNG TIN PHIÊN HỌP</h4>
        <div class="boder" style="padding: 10px;">
            <table class="table1">
                <tr style="display: none;">
                    <td>Loại quan hệ<span class="batbuoc">(*)</span></td>
                    <td>
                        <asp:DropDownList ID="ddlLoaiQuanhe" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQuanhe_SelectedIndexChanged">

                            <asp:ListItem Value="1" Text="Đề nghị"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>Quan hệ pháp luật<span class="batbuoc">(*)</span></td>
                    <td>
                        <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="400px"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Ngày quyết định<span class="batbuoc">(*)</span></td>
                    <td>
                        <asp:TextBox ID="txtNgaytuyenan" runat="server" CssClass="user" Width="90px" MaxLength="10" OnTextChanged="txtNgayquyetdinh_TextChanged" AutoPostBack="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytuyenan" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytuyenan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender1" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>

                    <td style="width: 140px;">Ngày mở phiên họp<span class="batbuoc">(*)</span></td>
                    <td>
                        <asp:TextBox ID="txtNgaymophientoa" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaymophientoa" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaymophientoa" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 146px;">Số quyết định<span class="batbuoc">(*)</span></td>
                    <td style="width: 199px;">
                        <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                    </td>
                    <td>Ngày hiệu lực</td>
                    <td>
                        <asp:TextBox ID="txtNgayhieuluc" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayhieuluc" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender3" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayhieuluc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender2" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                    </td>
                </tr>

                <tr>
                    <td>Kết quả xem xét KN<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                       <asp:DropDownList ID="ddlKetQuaPhucTham"
    CssClass="chosen-select chosen-450px"
    runat="server"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlKetQuaPhucTham_SelectedIndexChanged">
</asp:DropDownList>


                    </td>
                </tr>
                <tr>
                    <td>Lý do<span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlLyDoBanAn" CssClass="chosen-select chosen-450px " runat="server" Width="450px"></asp:DropDownList>

                    </td>
                </tr>
                <tr>
                    <td>Vụ việc quá hạn luật định ?</td>
                    <td>
                        <asp:RadioButtonList ID="rdVuAnQuaHan" AutoPostBack="true"
                            runat="server" RepeatDirection="Horizontal"
                            OnSelectedIndexChanged="rdVuAnQuaHan_SelectedIndexChanged">
                            <asp:ListItem Value="0">Không</asp:ListItem>
                            <asp:ListItem Value="1">Có</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <asp:Panel ID="pnNguyenNhanQuaHan" runat="server" Visible="false">
                    <tr>
                        <td>Nguyên nhân chủ quan</td>
                        <td>
                            <asp:RadioButtonList ID="rdNNChuQuan" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Không</asp:ListItem>
                                <asp:ListItem Value="1">Có</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td>Nguyên nhân khách quan
                        </td>
                        <td>
                            <asp:RadioButtonList ID="rdNNKhachQuan" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Không</asp:ListItem>
                                <asp:ListItem Value="1">Có</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </asp:Panel>
                <tr>
                    <td>File đính kèm</td>
                    <td colspan="3">
                        <asp:HiddenField ID="hddFilePath" runat="server" />

                        <asp:CheckBox ID="chkKySo" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                        <br />
                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                        <asp:HiddenField ID="hddSessionID" runat="server" />
                        <asp:HiddenField ID="hddURLKS" runat="server" />
                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                            </ul>
                        </div>
                        <div id="zonekythuong" style="display: none; margin-top: 10px; width: 80%;">
                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                        </div>

                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="3">
                        <asp:DataGrid ID="dgFile" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgFile_ItemCommand" OnItemDataBound="dgFile_ItemDataBound">
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
                                        Tên file
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TENFILE") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                    <HeaderTemplate>
                                        Download
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text="Tải về" CausesValidation="false" CommandName="Download" ForeColor="#0e7eee"
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
                    <td colspan="4" style="text-align: center;">
                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu thông tin" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                        <asp:Button ID="cmdHuyBanAn" runat="server" CssClass="buttoninput"
                            Text="Xóa thông tin" OnClick="cmdHuyBanAn_Click"
                            OnClientClick="return confirm('Bạn thực sự muốn xóa thông tin phiên họp này? ');" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div style="height: 200px"></div>
    <script type="text/javascript">
        function ValidInputData() {
            var txtSobanan = document.getElementById('<%=txtSobanan.ClientID%>')
            var lengthSoBanAn = txtSobanan.value.trim().length;
            if (lengthSoBanAn == 0) {
                alert('Bạn chưa nhập số bản án!');
                txtSobanan.focus();
                return false;
            }
            if (lengthSoBanAn > 20) {
                alert('Số bản án không nhập quá 20 ký tự. Hãy nhập lại!');
                txtSobanan.focus();
                return false;
            }
            var txtNgaymophientoa = document.getElementById('<%=txtNgaymophientoa.ClientID%>');
            var lengthNgayMoPhienToa = txtNgaymophientoa.value.trim().length;
            if (lengthNgayMoPhienToa == 0) {
                alert('Bạn chưa nhập ngày mở phiên tòa.');
                txtNgaymophientoa.focus();
                return false;
            }
            if (lengthNgayMoPhienToa > 0) {
                var arr = txtNgaymophientoa.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày mở phiên tòa theo định dạng (dd/MM/yyyy).');
                    txtNgaymophientoa.focus();
                    return false;
                }
            }
            var txtNgaytuyenan = document.getElementById('<%=txtNgaytuyenan.ClientID%>');
            var lengthNgayTuyenAn = txtNgaytuyenan.value.trim().length;
            if (lengthNgayTuyenAn == 0) {
                alert('Bạn chưa nhập ngày quyết định.');
                txtNgaytuyenan.focus();
                return false;
            }
            if (lengthNgayTuyenAn > 0) {
                var arr = txtNgaytuyenan.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày quyết định theo định dạng (dd/MM/yyyy).');
                    txtNgaytuyenan.focus();
                    return false;
                }
            }
            var txtNgayhieuluc = document.getElementById('<%=txtNgayhieuluc.ClientID%>');
            if (txtNgayhieuluc.value.trim().length > 0) {
                var arr = txtNgayhieuluc.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày hiệu lực theo định dạng (dd/MM/yyyy).');
                    txtNgayhieuluc.focus();
                    return false;
                }
            }


            return true;
        }
        function uploadComplete(sender) {
            __doPostBack('tctl00$UpdatePanel1', '');
        }
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
        function CheckKyso() {
            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');

            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }
        }
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
</asp:Content>
