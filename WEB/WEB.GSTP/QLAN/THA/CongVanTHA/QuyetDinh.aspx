<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QuyetDinh.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.CongVanTHA.QuyetDinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
        }

        .title_ds {
            float: left;
            width: 100%;
            background: #fff none repeat scroll 0 0;
            white-space: nowrap;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
    </style>
    <asp:HiddenField ID="hddCurrThuLyID" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="lstMsgTop" runat="server"></asp:Literal>
            </div>
            <div class="content_form">

                <!---------------------------------------->
                <div class="boxchung">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                    <h4 class="tleboxchung bg_title_group bg_green">
                        <asp:Literal ID="lttGroup" runat="server" Text="Quyết định"></asp:Literal></h4>
                    <div class="boder" style="padding: 20px 10px;">
                        <table class="table1">

                            <tr>
                                <td style="width: 120px;">Yêu cầu</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtYeuCau" CssClass="user" Enabled="false"
                                        runat="server" Width="568px"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 100px;">Lý do</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtLyDo" CssClass="user" Enabled="false"
                                        runat="server" Width="568px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 120px;">QĐ/TB<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="dropQuyetDinh_TB" runat="server" CssClass="chosen-select" AutoPostBack="true"
                                        OnSelectedIndexChanged="dropQuyetDinh_TB_SelectedIndexChanged"
                                        Width="577px">
                                    </asp:DropDownList>
                                    <%--  <asp:TextBox ID="txtQD" CssClass="user" Enabled="false"
                                        runat="server" Width="98%"></asp:TextBox>--%>
                                </td>
                            </tr>
                            <tr>
                                <td>Số QĐ/TB<span class="batbuoc">(*)</span></td>
                                <td style="width: 310px;">
                                    <asp:TextBox ID="txtSoQD" CssClass="user"
                                        runat="server" Width="200px"></asp:TextBox>

                                </td>
                                <td style="width: 100px;">Ngày ra QĐ/TB<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user"
                                        placeholder="ngày/tháng/năm"
                                        Width="140px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                        TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                        TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="border-bottom: dotted 1px #dcdcdc;"></td>
                            </tr>
                            <tr>
                                <td>Hiệu lực từ ngày<span class="batbuoc">(*)</span>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtHieuLuc_TuNgay" runat="server" Width="200px" CssClass="user" 
                                        placeholder="ngày/tháng/năm" ></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtHieuLuc_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtHieuLuc_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtHieuLuc_TuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <%------%>
                            <tr>
                                <td>Hiệu lực đến ngày<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayHieuLuc_DenNgay" runat="server" Width="140px"
                                        placeholder="ngày/tháng/năm" CssClass="user"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayHieuLuc_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayHieuLuc_DenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>

                            </tr>
                            <tr>
                                <td colspan="4" style="border-bottom: dotted 1px #dcdcdc;"></td>
                            </tr>

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
                                    <asp:TextBox ID="txtChucVu" runat="server" Width="140px" CssClass="user" disabled="disabled"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Kết quả<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdKetQua" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="0">Không chấp nhận</asp:ListItem>
                                        <asp:ListItem Value="1">Chấp nhận</asp:ListItem>
                                        <asp:ListItem Value="2">Chấp nhận một phần</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGhiChu" CssClass="user"
                                        runat="server" Width="568px"></asp:TextBox>
                                </td>
                            </tr>
                                <tr> 
                                    <td>Đính kèm tệp</td>
                                    <td colspan="5">
                                        <asp:HiddenField ID="hddFilePath" runat="server" />                                
                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                        <!------------------------>
                                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                            <asp:FileUpload ID="fileupload" runat="server" onchange="fileSelected()" style="display:none"/>
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:LinkButton ID="lkFile" runat="server"
                                                ToolTip="Bấm vào để tải file" OnClick="lkFile_Click"></asp:LinkButton>  
                                           <asp:ImageButton ID="cmdXoa" runat="server"
                                                ImageUrl="../../../UI/img/delete.png" ToolTip="Xóa"
                                                OnClientClick="return confirm('Bạn có thực sự muốn xóa tệp đính kèm này?');"
                                                Width="20px" OnClick="cmdXoa_Click" Visible="false"></asp:ImageButton>
                                        </div>
                                    </td>
                                </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="margin: 5px; text-align: center; width: 95%">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                            OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                                        <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput"
                                            Text="Quay lại" OnClick="cmdBack_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate() {
            var NgaySoSanh;
            var dropQuyetDinh_TB = document.getElementById('<%=dropQuyetDinh_TB.ClientID%>');
            value_change = dropQuyetDinh_TB.options[dropQuyetDinh_TB.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn quyết định/thông báo. Hãy kiểm tra lại!');
                dropQuyetDinh_TB.focus();
                return false;
            }
            //-----------------------
            var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
            if (!Common_CheckTextBox(txtSoQD, "số QĐ/TB"))
                return false;

            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
            if (!CheckDateTimeControl(txtNgayQD, 'Ngày ra QĐ/TB'))
                return false;

            //--------------
            var txtHieuLuc_TuNgay = document.getElementById('<%=txtHieuLuc_TuNgay.ClientID%>');
            if (!CheckDateTimeControl(txtHieuLuc_TuNgay, 'mục "Hiệu lực từ ngày"'))
                return false;
            var NgaySoSanh = txtNgayRaQD.value;
            if (!SoSanh2Date(txtHieuLuc_TuNgay, 'mục "Hiệu lực từ ngày"', NgaySoSanh, 'mục "Ngày ra quyết đinh/TB"')) {
                txtHieuLuc_TuNgay.focus();
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
        function set_ngayhieuluc() {

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
    </script>
    <script>
        function fileSelected() {
            // Lấy thông tin về tệp tin được chọn
            var fileInput = document.getElementById('<%=fileupload.ClientID%>');
            var selectedFile = fileInput.files[0]; // Chỉ lấy tệp tin đầu tiên nếu người dùng chọn nhiều tệp tin

            // Thực hiện các xử lý bạn muốn với tệp tin được chọn
            if (selectedFile) {
                console.log('File selected:', selectedFile.name);
                // Thêm mã xử lý khác tại đây
            }
        }
    </script>
</asp:Content>
