<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongTinVA.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.ThongTinVA" %>

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
    <asp:HiddenField ID="hdTrangThaiXacThucND" runat="server" Value="0" />
    <asp:HiddenField ID="hidTamTru_Huyen" runat="server" ClientIDMode="Static" />
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
                <div>
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Loại</td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select" Width="260px" runat="server"></asp:DropDownList>
                                    </td>
                                    <td style="display: none; width: 100px;">
                                        <asp:Label ID="checkuyquyen" runat="server">
                                            <asp:CheckBox ID="CheckBoxUyQuyen" runat="server" Font-Bold="true" Text="" Width="260px" onchange="UyQuyen(this)" />
                                        </asp:Label>
                                    </td>
                                    <td style="width: 90px;"><span class="batbuoc"></span></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td colspan="5" style="width: 640px;">
                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh" TextMode="MultiLine" Rows="2" runat="server" Width="640px" Enabled="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Tên bị án - Tội danh<span class="batbuoc">(*)</span></td>
                                    <td colspan="5" style="width: 640px;">
                                        <asp:TextBox ID="txtTenBiAnToiDanh" CssClass="user"
                                            TextMode="MultiLine" Rows="2" runat="server" Width="640px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Ngày xảy ra vụ án</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtNgayXayra" runat="server" CssClass="user" Width="260px" MaxLength="10"></asp:TextBox>
                                    </td>
                                    <td style="width: 100px; display: none">Tính chất bản án</td>
                                    <td style="display: none">
                                        <asp:DropDownList ID="dropTinhChatVuAn" CssClass="chosen-select"
                                            runat="server" Width="260px">
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td style="width: 100px;">Giai đoạn xét xử</td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlGDXX" CssClass="chosen-select"
                                            runat="server" Width="260px" AutoPostBack="true" OnSelectedIndexChanged="ddlGDXX_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Phúc thẩm"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lbNgayBanAn" runat="server"></asp:Label><span class="batbuoc">(*)</span>
                                    </td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user" Width="260px" MaxLength="10"></asp:TextBox>
                                    </td>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lbSoBanAn" runat="server"></asp:Label><span class="batbuoc">(*)</span>
                                    </td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtSoBanAn" CssClass="user align_right" onkeypress="return isNumber(event)" runat="server"
                                            Width="260px" MaxLength="50"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lbToaAn" runat="server"></asp:Label><span class="batbuoc">(*)</span>
                                    </td>
                                    <td style="width: 260px;">
                                        <asp:HiddenField ID="hddToaAnID" runat="server" />
                                        <asp:TextBox ID="txtToaAn" CssClass="user" runat="server" Width="260px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnGDXX" runat="server">
                                    <tr>
                                        <td style="width: 100px;">Ngày bản án sơ thẩm<span class="batbuoc">(*)</span>
                                        </td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtNgayBAST" runat="server" CssClass="user" Width="260px" MaxLength="10"></asp:TextBox>
                                        </td>
                                        <td style="width: 100px;">Số bản án sơ thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtSoBAST" runat="server" CssClass="user align_right" Width="260px" MaxLength="10"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100px;">Tòa án ra bản án sơ thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:HiddenField ID="hddToaAnIDST" runat="server" />
                                            <asp:TextBox ID="txtToaAnST" CssClass="user" runat="server" Width="260px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </div>
                    </div>

                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group"></h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Ngày sinh</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtNgaySinh" OnTextChanged="txtNgaySinh_TextChanged" runat="server" CssClass="user" Width="260px" MaxLength="10" ClientIDMode="Static"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaySinh" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaySinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender1" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                    </td>
                                    <td style="width: 100px;">Năm sinh <span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtNamSinh" runat="server" CssClass="user align_right" Width="260px" MaxLength="4" onkeypress="return isNumber(event)" ClientIDMode="Static"></asp:TextBox>
                                    </td>

                                    <td style="width: 100px;">Số CMND</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user align_right" Width="260px" MaxLength="20" onkeypress="return isNumber(event)" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                    <td style="width: 110px; padding-left: 10px;">Trạng thái xác thực:</td>
                                    <td>
                                        <asp:Label ID="lblTrangThaiXacThuc" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Số CCCD</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtSoCCCD" runat="server" CssClass="user align_right" Width="260px" MaxLength="20" onkeypress="return isNumber(event)" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                    <td style="width: 100px;">Ngày cấp</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtNgayCapCCCD" runat="server" CssClass="user" Width="260px" MaxLength="10" ClientIDMode="Static"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayCapCCCD" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayCapCCCD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender2" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                    </td>

                                    <td style="width: 100px;">
                                        <asp:CheckBox ID="chkKhongCo" AutoPostBack="true" runat="server" Text="Không có" />
                                    </td>
                                    <td style="width: 260px;">
                                        <asp:CheckBox ID="chkKhongLamSachND" AutoPostBack="true" runat="server" Text="Bị án Không thể làm sạch" style="margin-right: 5px;" />
                                        <asp:Button ID="btnKiemTra" runat="server" Text="Kiểm tra" CssClass="buttoninput" Height="25px" OnClick="btnGet037ND_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Họ và tên bố</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtHoTenBo" runat="server" CssClass="user" Width="260px" MaxLength="250" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                    <td style="width: 100px;">Họ và tên mẹ</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtHoTenMe" runat="server" CssClass="user" Width="260px" MaxLength="250" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Nơi cư trú<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlTamTru_Tinh" CssClass="chosen-select" runat="server" Width="130px" OnSelectedIndexChanged="ddlTamTru_Tinh_SelectedIndexChanged" ClientIDMode="Static"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTamTru_Huyen" CssClass="chosen-select" runat="server" Width="130px" ClientIDMode="Static"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">Địa chỉ chi tiết</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtTamtru_Chitiet" CssClass="user" runat="server" Width="260px" MaxLength="250" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Nơi DKHKTT<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlThuongTru_Tinh" CssClass="chosen-select" runat="server" Width="130px" OnSelectedIndexChanged="ddlThuongTru_Tinh_SelectedIndexChanged" ClientIDMode="Static"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlThuongTru_Huyen" CssClass="chosen-select" runat="server" Width="130px" ClientIDMode="Static"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">Địa chỉ chi tiết</td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtDiachichitiet_CQDN" CssClass="user" runat="server" Width="260px" MaxLength="250" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Đính kèm file</td>
                                    <td colspan="5">
                                        <asp:HiddenField ID="hddFilePath" runat="server" />
                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                        <!------------------------>
                                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                            <asp:FileUpload ID="fileupload" runat="server" onchange="fileSelected()" Style="display: none" />
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
                            </table>
                        </div>
                        <div style="margin: 5px; text-align: center; width: 95%;">
                            <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="cmdUpdateVuAn_Click"
                                OnClientClick="return validate_all();" />
                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                                Text="Xóa" OnClick="cmdQuaylai_Click" />
                        </div>
                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                            <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-------------------------------->
                    <asp:Panel ID="pnToiDanhChung" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung bg_title_group">Tội danh áp dụng cho các bị cáo </h4>
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
                                                <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />

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
                    <div class="boxchung" style="display: none;">
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
            </div>
        </div>
    </div>
    <div style="display: none">
        <asp:Button ID="cmdLoadDsBiDonKhac" runat="server"
            Text="Load ds BI don khac" OnClick="cmdLoadDsBiDonKhac_Click" />
    </div>
    <div style="display: none">
        <asp:Button ID="cmdLoadSessionBiAn" runat="server"
            Text="Load session" OnClick="cmdLoadSessionBiAn_Click" />
    </div>
    <script>
        function LoadDsBiCan() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
        }
        function LoadSessionBian() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadSessionBiAn.ClientID %>").click();
        }
    </script>
    <script type="text/javascript">
        var count_file = 0;
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

            // Ghi chú: Bỏ kiểm tra ngày hiệu lực bản án sơ thẩm vì control tương ứng đang bị ẩn/comment trong giao diện
            // if (!SoSanhDate(txtNgayAnCoHieuLucST, txtNgayBAST)) {
            //     alert('Xin vui lòng kiểm tra lại. "Ngày bản án sơ thẩm có hiệu lực" không thể nhỏ hơn "Ngày bản án sơ thẩm" !');
            //     txtNgayAnCoHieuLucST.focus();
            //     return false;
            // }

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

        function popup_them_bc() {
            var link = "/QLAN/THA/Hoso/DanhsachBiCan.aspx";
            var width = 800;
            var height = 900;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
            LoadModalDiv();
        }
        function popup_chon_bian_BA() {
            var link = "/QLAN/THA/Hoso/DanhsachBiCanBA.aspx";
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
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
    <script>
        function capNhatTrangThai() {
            var value = document.getElementById('<%= hdTrangThaiXacThucND.ClientID %>').value;
            var lbl = document.getElementById('<%= lblTrangThaiXacThuc.ClientID %>');

            if (value === "1") {
                lbl.innerText = "Đã xác thực";
            }
            else if (value === "0") {
                lbl.innerText = "Chưa xác thực";
            }
            else if (value === "3") {
                lbl.innerText = "Không thể làm sạch";
            }
        }
    </script>

</asp:Content>
