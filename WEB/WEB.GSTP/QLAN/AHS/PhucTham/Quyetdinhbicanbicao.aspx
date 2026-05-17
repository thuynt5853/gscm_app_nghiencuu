<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Quyetdinhbicanbicao.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.Quyetdinhbicanbicao" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .TenFile_css {
            color: inherit !important;
        }
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddThoiHanThang" Value="0" runat="server" />
    <asp:HiddenField ID="hddThoiHanNgay" Value="0" runat="server" />

    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin quyết định</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 110px;">Bị cáo<span class="batbuoc">(*)</span></td>
                            <td class="table_edit_col2">
                                <asp:DropDownList ID="ddlBiCan" CssClass="chosen-select"
                                    runat="server" Width="250px">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 122px;">Loại quyết định<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlLoaiQD" CssClass="chosen-select"
                                    runat="server" Width="250px"
                                    AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQD_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select"
                                    runat="server" Width="636px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <asp:Panel ID="pnLyDo" Visible="false" runat="server">
                            <tr>
                                <td>Lý do<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="636px"></asp:DropDownList>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnDieuLuatBS" runat="server" Visible="false">
                            <tr>
                                <td>Điều luật bổ sung</td>
                                <td>
                                    <asp:DropDownList ID="ddlDieuLuatBS" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Text="--- Chọn ---" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Điều 347" Value="347"></asp:ListItem>
                                        <asp:ListItem Text="Điều 358" Value="358"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Biên bản nghị án ngày</td>
                                <td>
                                    <asp:TextBox ID="txtNghiAnNgay" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNghiAnNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNghiAnNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td>Số Quyết định<asp:Literal ID="ltSoQD" runat="server"></asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                            </td>
                            <td>Ngày quyết định<asp:Literal ID="ltNgayQD" runat="server"></asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Người ký<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                            
                        </tr>
                        <%--<tr>
                            <td>Người ký<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNguoiKy" CssClass="user" Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                            <td>Chức vụ</td>
                            <td>
                                <asp:TextBox ID="txtChucvu" CssClass="user" Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                        </tr>--%>
                        <tr>
                            <td>Hiệu lực từ ngày<span class="batbuoc">(*)</span></td>
                            <td>
                                 <asp:TextBox ID="txtHieulucTuNgay" runat="server" CssClass="user" Width="242px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtHieulucTuNgay_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtHieulucTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtHieulucTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <asp:Panel ID="pnThoigiangiam" runat="server" Visible="false">
                            <td>Thời gian tạm giam<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtSoNgay" runat="server"
                                    onkeypress="return isNumber(event)"
                                    CssClass="user" Width="50px" MaxLength="10"
                                    AutoPostBack="true" OnTextChanged="txtSoNgay_TextChanged"></asp:TextBox>
                                ngày
                            </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td>Hiệu lực đến ngày<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtHieuLucDenNgay" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtHieuLucDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtHieuLucDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <asp:Panel ID="pnNoiGiamGiu" runat="server" Visible="false">
                            <tr>
                                <td>Nơi giam giữ<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoiGiamGiu" runat="server" CssClass="user" Width="628px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <div style="padding-right: 25px;">
                                        <asp:CheckBox ID="ch_tthp_va_khac" Font-Bold="true" runat="server"
                                            Text="Tổng hợp hình phạt từ vụ án khác" />
                                    </div>
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td>File đính kèm</td>
                            <td colspan="3">
                                <asp:HiddenField ID="hddFilePath" runat="server" />

                                <asp:CheckBox ID="chkKySo" Visible="false" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                <br />
                                <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                <asp:HiddenField ID="hddSessionID" runat="server" />
                                <asp:HiddenField ID="hddURLKS" runat="server" />
                                <div id="zonekyso" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                                    <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                    <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                    <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                    </ul>
                                </div>
                                <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                </div>


                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="HOTEN" HeaderText="Tên bị cáo" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TenQD" HeaderText="Tên Quyết định" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra QĐ" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKy" HeaderText="Người ký" HeaderStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                         <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate >
                                        <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                        <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidInputData() {
            var ddlBiCan = document.getElementById('<%=ddlBiCan.ClientID%>');
            var val = ddlBiCan.options[ddlBiCan.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn bị cáo. Hãy chọn lại!');
                ddlBiCan.focus();
                return false;
            }
            var ddlLoaiQD = document.getElementById('<%=ddlLoaiQD.ClientID%>');
            val = ddlLoaiQD.options[ddlLoaiQD.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn loại quyết định. Hãy chọn lại!');
                ddlLoaiQD.focus();
                return false;
            }
            var NgayThuLy = '<%= NgayThuLy%>';
            var arr = NgayThuLy.split('/');
            var DNgayThuLy = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
            var DateNow = Date.now();
            var ddlQuyetdinh = document.getElementById('<%=ddlQuyetdinh.ClientID%>');
            val = ddlQuyetdinh.options[ddlQuyetdinh.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn quyết định. Hãy chọn lại!');
                ddlQuyetdinh.focus();
                return false;
            }
            var textddlQuyetdinh = ddlQuyetdinh.options[ddlQuyetdinh.selectedIndex].text;
            if (textddlQuyetdinh.includes("11-HS") || textddlQuyetdinh.includes("12-HS")) {
                var txtNghiAnNgay = document.getElementById('<%=txtNghiAnNgay.ClientID%>');
                if (txtNghiAnNgay.value != "") {
                    if (!Common_IsTrueDate(txtNghiAnNgay.value)) {
                        txtNghiAnNgay.focus();
                        return false;
                    }
                    arr = txtNghiAnNgay.value.split('/');
                    var NgayNghiAn = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (NgayNghiAn < DNgayThuLy) {
                        alert('Biên bản nghị án ngày phải lớn hơn hoặc bằng ngày thụ lý phúc thẩm.');
                        txtNghiAnNgay.focus();
                        return false;
                    }
                    if (NgayNghiAn > DateNow) {
                        alert('Biên bản nghị án ngày phải nhỏ hơn hoặc bằng ngày hiện tại.');
                        txtNghiAnNgay.focus();
                        return false;
                    }
                }
            }
            var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
            if (!Common_CheckEmpty(txtSoQD.value)) {
                alert('Bạn chưa nhập số quyết định.');
                txtSoQD.focus();
                return false;
            }
            else {
                var lengthSoQD = txtSoQD.value.trim().length;
                if (lengthSoQD > 50) {
                    alert('Số quyết định không quá 50 ký tự. Hãy nhập lại!');
                    txtSoQD.focus();
                    return false;
                }
            }
            //--------------------------
            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
            if (Common_CheckEmpty(txtNgayQD.value)) {
                if (!Common_IsTrueDate(txtNgayQD.value))
                    return false
                if (!SoSanh2Date(txtNgayQD, 'Mục "Ngày quyết định"', NgayThuLy, 'mục "Ngày thụ lý phúc thẩm" '))
                    return false;
            } 
            //--------------------------
            var txtHieulucTuNgay = document.getElementById('<%=txtHieulucTuNgay.ClientID%>');
            if (!Common_IsTrueDate(txtHieulucTuNgay.value)) {
                txtHieulucTuNgay.focus();
                return false;
            }
            if (!SoSanh2Date(txtHieulucTuNgay, 'Mục "Hiệu lực từ ngày"', txtNgayQD.value, 'mục "Ngày quyết định" '))
                return false;
            var ddlLoaiQD = document.getElementById('<%=ddlLoaiQD.ClientID%>');
            val = ddlLoaiQD.options[ddlLoaiQD.selectedIndex].value;
            if (val != 3) {
                var txtHieuLucDenNgay = document.getElementById('<%=txtHieuLucDenNgay.ClientID%>');
                if (!Common_IsTrueDate(txtHieuLucDenNgay.value)) {
                    txtHieuLucDenNgay.focus();
                    return false;
                }
                if (!SoSanh2Date(txtHieuLucDenNgay, 'Mục "Hiệu lực đến ngày"', txtHieulucTuNgay.value, 'mục "Hiệu lực từ ngày" '))
                    return false;
            }

           

            //--------------------------------
            var LoaiQD_BatTamGiam = '<%=LoaiQD_BatTamGiam%>';
            if (ddlLoaiQD.options[ddlLoaiQD.selectedIndex].value == LoaiQD_BatTamGiam) {
                var txtNoiGiamGiu = document.getElementById('<%=txtNoiGiamGiu.ClientID%>');
                if (!Common_CheckEmpty(txtNoiGiamGiu.value)) {
                    alert('Chưa nhập nơi giam giữ. Hãy nhập lại.');
                    txtNoiGiamGiu.focus();
                    return false;
                }
                var lengthNoiGiamGiu = txtNoiGiamGiu.value.trim().length;
                if (lengthNoiGiamGiu > 250) {
                    alert('Nơi giam giữ không nhập quá 250 ký tự. Hãy nhập lại.');
                    txtNoiGiamGiu.focus();
                    return false;
                }
            }
            return true;
        }
        function uploadStart(sender, args) {
            var fileName = args.get_fileName();
            var fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            var validFilesTypes = ["exe", "dll", "msi", "bat"];
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.length; i++) {
                if (fileExt == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (isValidFile) {
                var err = new Error();
                err.name = "Lỗi tải lên";
                err.message = "Hệ thống không lưu trữ file định dạng (exe,dll,msi,bat). Hãy chọn lại!";
                throw (err);
                return false;
            } else {
                return true;
            }
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
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>
</asp:Content>
