<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Bananphuctham.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Phuctham.Bananphuctham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../UI/js/Common.js"></script>
    <link href="../../../UI/css/style.css" rel="stylesheet" />
    <style>
        .tleboxchung {
            text-transform: uppercase;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
    </style>
    <asp:HiddenField ID="hddShowBA" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanPhanCong" Value="" runat="server" />
    <asp:HiddenField ID="hddThoiHanThang" Value="0" runat="server" />
    <asp:HiddenField ID="hddThoiHanNgay" Value="0" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
    <asp:HiddenField ID="hddNgayThuLy" runat="server" Value="" />
    <asp:HiddenField ID="hddTGTTRowLastIndex" runat="server" Value="0" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="ttBanDauDONKK_USER_DKNHANVB" runat="server" Value="0" />
    <asp:Panel ID="pnBAPT" runat="server">
        <div class="boxchung">
            <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td colspan="4">
                            <asp:RadioButtonList ID="rdbPanelBA" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelBA_SelectedIndexChanged">
                                <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>Quan hệ pháp luật<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlQuanhephapluat" Visible="false" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                            <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder="" runat="server" Width="440px" MaxLength="500"></asp:TextBox>
                            <asp:DropDownList ID="ddlLoaiQuanhe" Visible="false" CssClass="chosen-select" runat="server" Width="300px">
                                <asp:ListItem Value="1" Text="Khiếu kiện"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 125px;">Số bản án<span class="batbuoc">(*)</span></td>
                        <td style="width: 214px;">
                            <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                        </td>
                        <td style="width: 121px;">Ngày mở phiên tòa<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgaymophientoa" AutoPostBack="true" OnTextChanged="txtNgaymophientoa_TextChanged" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaymophientoa" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaymophientoa" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                        </td>
                    </tr>
                    <tr>
                        <td>Có công bố bản án ?<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:RadioButtonList ID="rdCongboBA" AutoPostBack="true"
                                runat="server" RepeatDirection="Horizontal"
                                OnSelectedIndexChanged="rdCongboBA_SelectedIndexChanged">
                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>Ngày tuyên án<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgaytuyenan" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytuyenan" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytuyenan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender1" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                        </td>
                        <td>Ngày hiệu lực</td>
                        <td>
                            <asp:TextBox ID="txtNgayhieuluc" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayhieuluc" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender3" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayhieuluc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender2" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                        </td>
                    </tr>

                    <tr>
                        <td>Kết quả phúc thẩm<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlKetQuaPhucTham" CssClass="chosen-select" runat="server" Width="450px" AutoPostBack="true" OnSelectedIndexChanged="ddlKetQuaPhucTham_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Lý do bản án<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlLyDoBanAn" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">

                            <div class="boxchung">
                                <h4 class="tleboxchung">Các chỉ tiêu hỗ trợ thống kê</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>Yếu tố nước ngoài<span class="batbuoc">(*)</span>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlYeutonuocngoai" CssClass="chosen-select" runat="server" Width="110px">
                                                    <asp:ListItem Value="0" Text="--- Chọn ---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 135px;">Áp dụng án lệ?<span class="batbuoc">(*)</span></td>
                                            <td style="width: 195px;">
                                                <%--<asp:RadioButtonList ID="rdbAnle" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                </asp:RadioButtonList>--%>
                                                <asp:DropDownList runat="server" ID="ddlCBBA_Anle" CssClass="user"></asp:DropDownList>
                                            </td>
                                            <td style="width: 140px;">Có VKS tham gia?<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdbVKSThamgia" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                        </tr>

                                        <tr>
                                            <td>VKS có kháng nghị nhưng không được chấp nhận<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdVKSCoKN" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            <td>VKS rút kháng nghị nhưng đương sự không rút kháng cáo<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdVKSRutKN" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <%--                                        <tr>
                                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                        </tr>--%>
                                        <%-- <tr>
                                            <td style="width: 125px;">Vụ án quá hạn luật định</td>
                                            <td style="width: 195px;">
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
                                        </asp:Panel>--%>
                                        <tr>
                                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <asp:Label ID="Label1" runat="server" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>


                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <asp:Panel ID="pnZonekythuong" runat="server">
                            <td>File đính kèm</td>
                            <td colspan="3">
                                <asp:HiddenField ID="hddFilePath" runat="server" />

                                <%--<asp:CheckBox ID="chkKySo" Checked="true" runat="server" AutoPostBack="true" OnCheckedChanged="cmd_load_form_Click" Text="Sử dụng ký số file đính kèm" />--%>
                                <br />
                                <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                <asp:HiddenField ID="hddSessionID" runat="server" />
                                <asp:HiddenField ID="hddURLKS" runat="server" />
                                <%--<div id="zonekyso" runat="server" style="margin-bottom: 5px; margin-top: 10px;">
                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                            </ul>
                        </div>--%>
                                <div id="zonekythuong" runat="server" style="display: block; margin-top: 10px; width: 80%;">
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        OnClientUploadStarted="onUploadStartBA"
                                        OnClientUploadComplete="onUploadCompleteBA"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <div id="loadingIndicatorBA" style="display: none; color: red;">Đang tải file...</div>
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
                        </asp:Panel>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Label ID="LsbErrorExtension" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <asp:Panel ID="pnDgFile" runat="server">
                            <td></td>
                            <td colspan="3">
                                <asp:DataGrid ID="dgFile" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgFile_ItemCommand">
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
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </asp:Panel>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Label ID="lstErr" runat="server" ForeColor="Red"></asp:Label>
                            <asp:Label ID="lbthongbao" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu thông tin bản án" OnClientClick="return ValidInputData();" OnClick="cmdUpdate_Click" />
                            <asp:Button ID="cmdHuyBanAn" runat="server" CssClass="buttoninput"
                                Text="Xóa bản án" OnClick="cmdHuyBanAn_Click"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản án này? ');" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnQDVV" runat="server" Visible="false" ChildrenAsTriggers="true" ClientIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelQD" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelQD_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>Loại quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlLoaiQD" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="true" ClientIDMode="AutoID" OnSelectedIndexChanged="ddlLoaiQD_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="true" ClientIDMode="AutoID" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="QDVACol1">Ngày mở phiên tòa <span class="batbuoc">(*)</span></td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="txtNgayMoPhienToaQD" runat="server" CssClass="user"
                                        Width="100px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="QDVACol3">Địa điểm</td>
                                <td>
                                    <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <asp:Panel ID="pnKetquaPhuctham" runat="server" Visible="false">
                                <tr>
                                    <td>Kết quả phúc thẩm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlKetquaQuyetdinh" CssClass="chosen-select" runat="server" Width="450px" AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaQuyetdinh_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnLyDoKetquaPhuctham" runat="server" Visible="false">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydoQuyetdinh" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnLyDo" runat="server">
                                <tr>
                                    <td>Lý do</td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="true" OnSelectedIndexChanged="ddlLydo_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pntxtLydo" runat="server">
                                <tr>
                                    <td id="lbtxtLydo" runat="server" visible="false"></td>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtLydo" CssClass="user" placeholder="" runat="server" Width="640px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnQHPL" Visible="false" runat="server">
                                <tr>
                                    <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlQHPLQDVV" CssClass="chosen-select" runat="server" Width="650px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnCongBoQD" Visible="false" runat="server">
                                <tr>
                                    <td>Có công bố quyết định?<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdCongBoQD" AutoPostBack="true"
                                            runat="server" RepeatDirection="Horizontal"
                                            OnSelectedIndexChanged="rdCongboQD_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td class="QDVACol1">Số Quyết định <span class="batbuoc">(*)</span></td>
                                <td class="QDVACol2">
                                    <%--<asp:TextBox ID="txtSoQD" runat="server" placeholder="Số tự sinh" CssClass="user" Width="242" MaxLength="20"></asp:TextBox>--%>
                                    <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="242" MaxLength="20"></asp:TextBox>
                                </td>
                                <td class="QDVACol3">Ngày quyết định <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <asp:Panel ID="pnDuongSuYC" runat="server" Visible="false">
                                <tr>
                                    <td>Người yêu cầu</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiYC" runat="server" CssClass="chosen-select" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlNguoiYC_SelectedIndexChanged"></asp:DropDownList></td>
                                    <td>Người bị yêu cầu</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiBiYC" runat="server" CssClass="chosen-select" Width="250px"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Nội dung yêu cầu</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoiDungYC" runat="server" TextMode="MultiLine" Height="30px" Width="648px"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Hiệu lực từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieuLucTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtHieuLucTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtHieuLucTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Hiệu lực đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieuLucDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtHieuLucDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtHieuLucDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Người ký</td>
                                <td>
                                    <asp:TextBox ID="txtNguoiKyTTVV" CssClass="user" Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                                <td>Chức vụ</td>
                                <td>
                                    <asp:TextBox ID="txtChucvu" CssClass="user"
                                        Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePathQD" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadQD" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedCompleteQD"
                                        OnClientUploadStarted="onUploadStartQD"
                                        OnClientUploadComplete="onUploadCompleteQD"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <%--<asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />--%>
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                    <div id="loadingIndicatorQD" style="display: none; color: red;">Đang tải file...</div>
                                </td>
                            </tr>
                            <asp:Panel runat="server" ID="pnDownload" Visible="false">
                                <tr>
                                    <td>Tệp đính kèm</td>
                                    <td colspan="3">
                                        <asp:HiddenField ID="HiddenField1" runat="server" />
                                        <asp:CheckBox ID="chkKySo" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                        <br />
                                        <asp:HiddenField ID="HiddenField2" runat="server" Value="" />
                                        <asp:HiddenField ID="HiddenField3" runat="server" />
                                        <asp:HiddenField ID="HiddenField4" runat="server" />
                                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                            </ul>
                                        </div>
                                        <%--<div id="zonekythuong" style="display: none; margin-top: 10px; width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad1" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>--%>
                                    </td>
                                </tr>
                                <%--<tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                                </tr>--%>
                            </asp:Panel>
                        </table>
                    </div>
                </div>
                <asp:Panel ID="pnChiTieuThongKe" runat="server">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Các chỉ tiêu hỗ trợ thống kê</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>Yếu tố nước ngoài<span class="batbuoc">(*)</span>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlYeutonuocngoaiQD" CssClass="chosen-select" runat="server" Width="110px">
                                            <asp:ListItem Value="0" Text="--- Chọn ---" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="width: 135px;">Áp dụng án lệ?<span class="batbuoc">(*)</span></td>
                                    <td style="width: 195px;">
                                        <%--<asp:RadioButtonList ID="rdbAnleQD" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>--%>
                                        <asp:DropDownList runat="server" ID="ddlCBBA_AnleQD" CssClass="user"></asp:DropDownList>
                                    </td>
                                    <asp:Panel ID="pnVKSThamgia" runat="server">
                                        <td style="width: 140px;">Có VKS tham gia?<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbVKSThamgiaQD" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </asp:Panel>
                                </tr>

                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:Label ID="Label3" runat="server" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </asp:Panel>
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" Enabled="true"
                                    Text="Lưu" OnClick="btnUpdate_Click"
                                    OnClientClick="return validate();" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <asp:Label ID="lbthongbaoQD" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="Label2" ForeColor="Red"></asp:Label>
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
                                                    Tên Quyết định
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TenQD") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SOQD" HeaderText="Số QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NguoiKy" HeaderText="Người ký" HeaderStyle-Width="95px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="TENTOAAN" HeaderText="Tòa án ra QĐ" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                            <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                                <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                        CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                    <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thao tác
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
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
    </asp:Panel>
    <script type="text/javascript">
        function validate() {
            var ddlYeutonuocngoaiQD = document.getElementById('<%=ddlYeutonuocngoaiQD.ClientID%>');
            val = ddlYeutonuocngoaiQD.options[ddlYeutonuocngoaiQD.selectedIndex].value;
            if (val == 0) {
                alert("Bạn chưa chọn Yếu tố nước ngoài. Hãy chọn lại!");
                ddlYeutonuocngoaiQD.focus();
                return false;
            }
            var rdbVKSThamgiaQD = document.getElementById('<%=rdbVKSThamgiaQD.ClientID%>');
            if (!CheckChangeRadioButtonList(rdbVKSThamgiaQD, 'Chưa chọn "Có VKS tham gia?". Hãy chọn lại!'))
                return false;
        }
        function ValidInputData() {

            //Các chỉ tiêu hỗ trợ thống kê
            var rdbVKSThamgia = document.getElementById('<%=rdbVKSThamgia.ClientID%>');
            if (!CheckChangeRadioButtonList(rdbVKSThamgia, 'Chưa chọn "Có VKS tham gia?". Hãy chọn lại!'))
                return false;
            var rdVKSCoKN = document.getElementById('<%=rdVKSCoKN.ClientID%>');
            if (!CheckChangeRadioButtonList(rdVKSCoKN, 'Chưa chọn "VKS có kháng nghị nhưng không được chấp nhận". Hãy chọn lại!'))
                return false;
            var rdVKSRutKN = document.getElementById('<%=rdVKSRutKN.ClientID%>');
            if (!CheckChangeRadioButtonList(rdVKSRutKN, 'Chưa chọn "VKS rút kháng nghị nhưng đương sự không rút kháng cáo". Hãy chọn lại!'))
                return false;

            //Quan hệ pháp luật
            var txtQuanhephapluat = document.getElementById('<%=txtQuanhephapluat.ClientID%>')
            if (!Common_CheckTextBox(txtQuanhephapluat, "Quan hệ pháp luật"))
                return false;
            var lengthQhpl = txtQuanhephapluat.value.trim().length;
            if (lengthQhpl > 500) {
                alert('Quan hệ pháp luật nhập quá dài!');
                txtQuanhephapluat.focus();
                return false;
            }

            //Số bản án và Ngày mở phiên tòa
            var txtSobanan = document.getElementById('<%=txtSobanan.ClientID%>')
            if (!Common_CheckTextBox(txtSobanan, "Số bản án"))
                return false;
            var lengthSoBanAn = txtSobanan.value.trim().length;
            if (lengthSoBanAn > 20) {
                alert('Số bản án không nhập quá 20 ký tự. Hãy nhập lại!');
                txtSobanan.focus();
                return false;
            }

            var txtNgaymophientoa = document.getElementById('<%=txtNgaymophientoa.ClientID%>');
            var lengthNgayMoPhienToa = txtNgaymophientoa.value.trim().length;
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgaymophientoa, 'Ngày mở phiên tòa'))
                return false;

            //Công bố bản án
            var rdCongboBA = document.getElementById('<%=rdCongboBA.ClientID%>')
            if (!CheckChangeRadioButtonList(rdCongboBA, "Chưa chọn có/không công bố bán án!"))
                return false;

            //Ngày tuyên án và ngày hiệu lực bán án
            var txtNgaytuyenan = document.getElementById('<%=txtNgaytuyenan.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgaytuyenan, 'Ngày tuyên án'))
                return false;

            var txtNgayhieuluc = document.getElementById('<%=txtNgayhieuluc.ClientID%>');
            if (Common_CheckEmpty(txtNgayhieuluc.value)) {
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgayhieuluc, 'Ngày hiệu lực'))
                    return false;
            }

            //Kết quả phúc thẩm và lý do bản án
            var ddlKetQuaPhucTham = document.getElementById('<%=ddlKetQuaPhucTham.ClientID%>');
            val = ddlKetQuaPhucTham.options[ddlKetQuaPhucTham.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!');
                ddlKetQuaPhucTham.focus();
                return false;
            }

            var ddlLyDoBanAn = document.getElementById('<%=ddlLyDoBanAn.ClientID%>');
            val = ddlLyDoBanAn.options[ddlLyDoBanAn.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!');
                ddlLyDoBanAn.focus();
                return false;
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
       <%-- function CheckKyso() {
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
            var received_msg = JSON.parse(rv); S
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }
        function onUploadStartQD(sender, args) {
            document.getElementById('loadingIndicatorQD').style.display = 'block';
            document.getElementById('<%= btnUpdate.ClientID %>').disabled = true;
        }

        function onUploadCompleteQD(sender, args) {
            document.getElementById('loadingIndicatorQD').style.display = 'none';
            document.getElementById('<%= btnUpdate.ClientID %>').disabled = false;
        }
        function onUploadStartBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'block';
            document.getElementById('<%= cmdUpdate.ClientID %>').disabled = true;
        }

        function onUploadCompleteBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'none';
            document.getElementById('<%= cmdUpdate.ClientID %>').disabled = false;
        }
    </script>
</asp:Content>
