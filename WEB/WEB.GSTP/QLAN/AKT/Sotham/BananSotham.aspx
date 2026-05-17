<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BananSotham.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.Sotham.BananSotham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowBA" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanPhanCong" Value="" runat="server" />
    <asp:HiddenField ID="hddThoiHanThang" Value="0" runat="server" />
    <asp:HiddenField ID="hddThoiHanNgay" Value="0" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayThuLy" runat="server" Value="" />
    <asp:HiddenField ID="hddTGTTRowLastIndex" runat="server" Value="0" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="ttBanDauDONKK_USER_DKNHANVB" runat="server" Value="0" />
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

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }
    </style>
    <asp:Panel ID="pnBAST" runat="server">
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
                            <asp:DropDownList ID="ddlQuanhephapluat" Visible="false" CssClass="chosen-select" runat="server" Width="450px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged"></asp:DropDownList>
                            <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder="" runat="server" Width="440px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>

                            <asp:DropDownList ID="ddlLoaiQuanhe" Visible="false" CssClass="chosen-select" runat="server" Width="300px">
                                <asp:ListItem Value="1" Text="Tranh chấp"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Yêu cầu"></asp:ListItem>
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
                        <td>Người Ký<span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtNguoiKy" CssClass="user" runat="server" Width="442px" Enabled="false"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 156px;">Số bản án<span class="batbuoc">(*)</span></td>
                        <td style="width: 211px;">
                            <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                        </td>
                        <td style="width: 123px;">Ngày mở phiên tòa<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgaymophientoa" AutoPostBack="true" OnTextChanged="txtNgaymophientoa_TextChanged" runat="server" CssClass="user" Width="95px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaymophientoa" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaymophientoa" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                        </td>
                    </tr>
                    <tr>
                        <td>Ngày tuyên án<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtNgaytuyenan" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytuyenan" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytuyenan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                        </td>
                        <td>Ngày hiệu lực</td>
                        <td>
                            <asp:TextBox ID="txtNgayhieuluc" runat="server" CssClass="user" Width="95px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayhieuluc" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender3" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayhieuluc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                        </td>
                    </tr>
                    <tr>
                        <td>Tóm tắt nội dung BA</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTomtatnoidungBanan" CssClass="user" runat="server" Rows="4"
                                onkeyup="updateWordCountdownBanan()" placeholder="Tối đa 200 từ."
                                Style="width: 449px" MaxLength="2000" TextMode="MultiLine"></asp:TextBox><br />
                            <span id="wordCountdownBanan" runat="server">Số từ còn lại: 200</span><br />
                            <span runat="server" id="charLimitMessageBanan" style="color: red;"></span>
                            <!-- Character limit message -->
                        </td>
                    </tr>
                    <%--<tr>
                        <td>Có công bố bản án ?<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:RadioButtonList ID="rdCongboBA"
                                runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Không</asp:ListItem>
                                <asp:ListItem Value="1">Có</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="4">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Các chỉ tiêu hỗ trợ thống kê</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 158px;">Áp dụng án lệ ?<span class="batbuoc">(*)</span></td>
                                            <td style="width: 150px;">
                                                <%-- <asp:RadioButtonList ID="rdbAnle" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                </asp:RadioButtonList>--%>
                                                <asp:DropDownList runat="server" ID="ddlCBBA_Anle" CssClass="user"></asp:DropDownList>
                                            </td>
                                            <td style="width: 168px;">Có VKS tham gia ?<span class="batbuoc">(*)</span></td>
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
                                            <td>Yếu tố nước ngoài ?<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlYeutonuocngoai" CssClass="chosen-select" runat="server" Width="110px">
                                                    <asp:ListItem Value="0" Text="--- Chọn ---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Số quyết định cá biệt trái pháp luật của cơ quan, tổ chức bị Tòa án hủy<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtSoQDTraiPL" runat="server" CssClass="user align_right" onkeypress="return isNumber(event)"
                                                    Width="90px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                        </tr>
                                        <tr>
                                            <td>Vụ án quá hạn luật định ?<span class="batbuoc">(*)</span></td>
                                            <td colspan="3">
                                                <asp:RadioButtonList ID="rdVuAnQuaHan"
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
                            <td>Tệp đính kèm</td>
                            <td colspan="3">
                                <asp:HiddenField ID="hddFilePath" runat="server" />

                                <%--<asp:CheckBox ID="chkKySo" Checked="true" runat="server" AutoPostBack="True" OnCheckedChanged="cmd_load_form_Click" Text="Sử dụng ký số file đính kèm" />--%>
                                <br />
                                <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                <asp:HiddenField ID="hddSessionID" runat="server" />
                                <asp:HiddenField ID="hddURLKS" runat="server" />
                                <%--                        <div id="zonekyso" runat="server" style="margin-bottom: 5px; margin-top: 10px;">
                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                            </ul>
                        </div>--%>
                                <div id="zonekythuong" runat="server" style="display: block; margin-top: 10px; width: 80%;">
                                    <%--<cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                    OnClientUploadComplete="UploadGrid" ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />--%>
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern"
                                        OnClientUploadStarted="onUploadStartBA"
                                        OnClientUploadComplete="onUploadCompleteBA"
                                        OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <div id="loadingIndicatorBA" style="display: none; color: red;">Đang tải file...</div>
                                    <%--<asp:Button ID="lbtDownload" CssClass="buttoninput" Visible="true" runat="server" Text="Download" OnClick="lbtDownload_Click" />--%>
                                </div>
                                <div style="display: none">
                                    <asp:Button ID="cmdThemFileTL" runat="server"
                                        Text="Them tai lieu" OnClick="cmdThemFileTL_Click" />
                                    <asp:Button ID="cmd_load_form" runat="server"
                                        Text="Lưu File" CausesValidation="false" OnClick="cmd_load_form_Click" />
                                    <%--<script>
                                    function UploadGrid(sender) {
                                        __doPostBack('<%= dgFile.UniqueID %>', '');

                                    }
                                </script>--%>
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
                        <td colspan="4" align="center">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu thông tin bản án" OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                            <asp:Button ID="cmdHuyBanAn" runat="server" CssClass="buttoninput"
                                Text="Xóa bản án" OnClick="cmdHuyBanAn_Click"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản án này? ');" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <asp:Label ID="lbthongbaoA" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel ID="pnAnPhi" runat="server">
            <div class="boxchung">
                <h4 class="tleboxchung">ĐIỀU LUẬT ÁP DỤNG</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 135px;">Bộ Luật áp dụng<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlBoLuat" CssClass="chosen-select" runat="server" Width="400px" AutoPostBack="True" OnSelectedIndexChanged="ddlBoLuat_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Điều khoản áp dụng<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlDieukhoan" CssClass="chosen-select" runat="server" Width="400px"></asp:DropDownList></td>
                        </tr>

                        <tr>
                            <td colspan="2" align="center">
                                <asp:Button ID="cmdLuatUpdate" runat="server" CssClass="buttoninput" Text="Thêm mới điều khoản" OnClick="cmdLuatUpdate_Click" />


                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Label ID="lstMsgDieuluat" runat="server" ForeColor="Red"></asp:Label>


                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:DataGrid ID="dgDieuLuat" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgDieuLuat_ItemCommand">
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
                                                Bộ luật
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENBOLUAT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                            <HeaderTemplate>
                                                Tên điều khoản
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTOIDANH") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Điểm
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIEM") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Khoản
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("KHOAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Điều
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIEU") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Hủy" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn hủy điều luật này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>

                            </td>

                        </tr>

                    </table>
                </div>
            </div>
        </asp:Panel>
        <div class="boxchung">
            <h4 class="tleboxchung">THÔNG TIN ÁN PHÍ</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td>
                            <asp:DataGrid ID="dgAnPhi" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
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
                                            Tên đương sự
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENDUONGSU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="111px">
                                        <HeaderTemplate>
                                            Tham gia phiên tòa
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkThamgia" runat="server" Checked='<%# GetNumber(Eval("ISTHAMGIA"))%>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkThamgia_CheckChange" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                                        <HeaderTemplate>
                                            Ngày nhận bản án
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgaynhanbanan" runat="server" Text='<%# GetTextDate(Eval("NGAYNHANAN"))%>' CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNgaynhanbanan_CalendarExtender" runat="server" TargetControlID="txtNgaynhanbanan" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNgaynhanbanan_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhanbanan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                        <HeaderTemplate>
                                            Miễn án phí
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkMien" runat="server" Checked='<%# GetNumber(Eval("MIENANPHI"))%>' ToolTip='<%#Eval("ID")%>' AutoPostBack="true" OnCheckedChanged="chkMien_CheckChange" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                        <HeaderTemplate>
                                            Án phí
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtAnphi" runat="server" Style="text-align: right; padding-right: 5px;" Text='<%#Eval("ANPHI")+""==""?"":Convert.ToDouble(Eval("ANPHI")).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) %>' CssClass="user" Width="90%" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lstMsgAnphi" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdAnphi" runat="server" CssClass="buttoninput" Text="Lưu án phí" OnClick="cmdAnphi_Click" />
                            <asp:Button ID="cmdXoaAnphi" runat="server" CssClass="buttoninput"
                                Text="Xóa án phí" OnClick="cmdXoaAnphi_Click"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa án phí? ');" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="boxchung">
            <h4 class="tleboxchung">THÔNG TIN NGƯỜI THAM GIA TỐ TỤNG</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td>
                            <asp:DataGrid ID="dgTGTT" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgTGTT_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
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
                                            Tên người tham gia tố tụng
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HOTEN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="111px">
                                        <HeaderTemplate>
                                            Tham gia phiên tòa
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkThamgiaTGTT" runat="server" Checked='<%# GetNumber(Eval("ISTHAMGIA"))%>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkThamgiaTGTT_CheckChange" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                                        <HeaderTemplate>
                                            Ngày nhận bản án
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayTGTT" runat="server" Text='<%# GetTextDate(Eval("NGAYNHANBANAN"))%>' CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNgayTGTT_CalendarExtender" runat="server" TargetControlID="txtNgayTGTT" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNgayTGTT_MaskedEditExtender3" runat="server" TargetControlID="txtNgayTGTT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tư cách tham gia tố tụng
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENTUCACH") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblMsgTGTT" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdTGTT" runat="server" CssClass="buttoninput" Text="Lưu thông tin" OnClick="cmdTGTT_Click" />
                            <asp:Button ID="cmdXoaTGTT" runat="server" CssClass="buttoninput"
                                Text="Xóa thông tin" OnClick="cmdXoaTGTT_Click"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa thông tin này? ');" />
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
                            <asp:Panel ID="pnQHPL" runat="server">
                                <tr>
                                    <td>Quan hệ pháp luật<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtQHPLQDVV" CssClass="user" placeholder="" runat="server" Width="440px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlQHPLQDVV" CssClass="chosen-select" runat="server" Width="650px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr style="display: none;">
                                <td>Loại quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlLoaiQD" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiQD_SelectedIndexChanged">
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
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayMoPhienToaQD"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayMoPhienToaQD"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="QDVACol3">Địa điểm</td>
                                <td>
                                    <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <asp:Panel ID="pnLyDo" Visible="false" runat="server">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="true"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnCBQD" Visible="false" runat="server">
                                <tr>
                                    <td>Có công bố quyết định?<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdCongBoQD"
                                            runat="server" RepeatDirection="Horizontal">
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
                                <td>Tóm tắt nội dung Quyết định</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtTomtatnoidungQuyetdinh" CssClass="user" runat="server" Rows="4"
                                        onkeyup="updateWordCountdownQuyetdinh()" placeholder="Tối đa 200 từ."
                                        Style="width: 449px" MaxLength="2000" TextMode="MultiLine"></asp:TextBox><br />
                                    <span id="wordCountdownQuyetdinh" runat="server">Số từ còn lại: 200</span><br />
                                    <span runat="server" id="charLimitMessageQuyetdinh" style="color: red;"></span>
                                    <!-- Character limit message -->
                                </td>
                            </tr>
                            <tr>
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePathQD" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadQD" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern"
                                        OnClientUploadStarted="onUploadStartQD"
                                        OnClientUploadComplete="onUploadCompleteQD"
                                        OnUploadedComplete="AsyncFileUpLoad_UploadedCompleteQD"
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

                <asp:Panel runat="server" ID="pnChiTieuThongKe" Visible="false">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Các chỉ tiêu hỗ trợ thống kê</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 158px;">Áp dụng án lệ ?<span class="batbuoc">(*)</span></td>
                                    <td style="width: 150px;">
                                        <%--<asp:RadioButtonList ID="rdbAnle_QD" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                </asp:RadioButtonList>--%>
                                        <asp:DropDownList runat="server" ID="ddlCBBA_AnleQD" CssClass="user"></asp:DropDownList>
                                    </td>
                                    <asp:Panel ID="pnVKSThamGia" runat="server">
                                        <td style="width: 140px;">Có VKS tham gia?<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbVKSThamgia_QD" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </asp:Panel>
                                    <asp:Panel ID="pnHoaGiaiThanh" runat="server" Visible="false">
                                        <td style="width: 140px;">Tòa án tổ chức Hòa giải thành?<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdqHoaGiaiThanhQD" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="6" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Yếu tố nước ngoài ?<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlYeutonuocngoai_QD" CssClass="chosen-select" runat="server" Width="110px">
                                            <asp:ListItem Value="0" Text="--- Chọn ---" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>Số quyết định cá biệt trái pháp luật của cơ quan, tổ chức bị Tòa án hủy ?<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoQDTraiPLBiHuy_QD" CssClass="user align_right"
                                            runat="server" Width="100px" onkeypress="return isNumber(event)"></asp:TextBox></td>
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
                                    Text="Lưu" OnClick="btnUpdate_Quyetdinh_Click"
                                    OnClientClick="return validate();" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddID" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="lbthongbaoQD" ForeColor="Red"></asp:Label>
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
    </asp:Panel>
    <script type="text/javascript">
        // Hàm xử lý sự kiện nhập liệu hoặc dán văn bản
        function updateWordCountdownBanan() {
            var textArea = document.getElementById('<%= txtTomtatnoidungBanan.ClientID %>');
            var charCount = document.getElementById('<%= wordCountdownBanan.ClientID %>');
            var charLimitMessage = document.getElementById('<%= charLimitMessageBanan.ClientID %>'); // Phần tử hiển thị thông báo giới hạn 200 từ

            // Lấy nội dung văn bản từ textbox
            var text = textArea.value.trim();

            // Nếu văn bản trống, hiển thị 200 từ còn lại
            if (text === "") {
                charCount.innerHTML = "Số từ còn lại: 200";
                charLimitMessage.innerHTML = "";  // Xóa thông báo nếu không có văn bản
                return;
            }

            // Tách nội dung văn bản thành các từ riêng biệt
            var words = text.split(/\s+/);  // Tách theo khoảng trắng (khoảng, tab, newline)

            // Đếm số lượng từ
            var wordCount = words.length;

            // Cập nhật hiển thị số từ còn lại
            var remainingWords = 200 - wordCount; // Số từ còn lại trong giới hạn 200 từ
            charCount.innerHTML = "Số từ còn lại: " + remainingWords;

            // Nếu có hơn 200 từ, chỉ giữ lại 200 từ đầu tiên
            if (wordCount > 200) {
                words = words.slice(0, 200); // Cắt mảng chỉ lấy 200 từ đầu tiên
                textArea.value = words.join(' '); // Gán lại giá trị cho textbox với 200 từ đầu tiên
                charLimitMessage.innerHTML = "Bạn đã đạt giới hạn 200 từ.";  // Hiển thị thông báo đạt giới hạn
            } else {
                charLimitMessage.innerHTML = "";  // Xóa thông báo nếu số từ ít hơn 200
            }
        }

        // Hàm xử lý sự kiện nhập liệu hoặc dán văn bản cho trường Quyết định
        function updateWordCountdownQuyetdinh() {
            var textArea = document.getElementById('<%= txtTomtatnoidungQuyetdinh.ClientID %>');
            var charCount = document.getElementById('<%= wordCountdownQuyetdinh.ClientID %>');
            var charLimitMessage = document.getElementById('<%= charLimitMessageQuyetdinh.ClientID %>'); // Phần tử hiển thị thông báo giới hạn 200 từ

            // Lấy nội dung văn bản từ textbox
            var text = textArea.value.trim();

            // Nếu văn bản trống, hiển thị 200 từ còn lại
            if (text === "") {
                charCount.innerHTML = "Số từ còn lại: 200";
                charLimitMessage.innerHTML = "";  // Xóa thông báo nếu không có văn bản
                return;
            }

            // Tách nội dung văn bản thành các từ riêng biệt
            var words = text.split(/\s+/);  // Tách theo khoảng trắng (khoảng, tab, newline)

            // Đếm số lượng từ
            var wordCount = words.length;

            // Cập nhật hiển thị số từ còn lại
            var remainingWords = 200 - wordCount; // Số từ còn lại trong giới hạn 200 từ
            charCount.innerHTML = "Số từ còn lại: " + remainingWords;

            // Nếu có hơn 200 từ, chỉ giữ lại 200 từ đầu tiên
            if (wordCount > 200) {
                words = words.slice(0, 200); // Cắt mảng chỉ lấy 200 từ đầu tiên
                textArea.value = words.join(' '); // Gán lại giá trị cho textbox với 200 từ đầu tiên
                charLimitMessage.innerHTML = "Bạn đã đạt giới hạn 200 từ.";  // Hiển thị thông báo đạt giới hạn
            } else {
                charLimitMessage.innerHTML = "";  // Xóa thông báo nếu số từ ít hơn 200
            }
        }
    </script>

    <script type="text/javascript">
        function validate() {
            var msg = "";
            var ddlQHPLTK = document.getElementById('<%= ddlQHPLTK.ClientID%>');
            if (ddlQHPLTK !== null) {
                var value_change = ddlQHPLTK.options[ddlQHPLTK.selectedIndex].value;
                if (value_change == "0" && ddlQHPLTK !== null) {
                    alert('Bạn chưa chọn mục "QHPL dùng cho thống kê". Hãy kiểm tra lại!');
                    ddlQHPLTK.focus();
                    return false;
                }
            }
            //----------------------
            var txtSobanan = document.getElementById('<%=txtSobanan.ClientID%>');
            if (txtSobanan !== null && !Common_CheckEmpty(txtSobanan.value)) {
                alert('Bạn chưa nhập "Số bản án".Hãy kiểm tra lại!');
                txtSobanan.focus();
                return false;
            }
            //----------------------
            var txtNgaymophientoa = document.getElementById('<%=txtNgaymophientoa.ClientID%>');
            if (txtNgaymophientoa !== null && !CheckDateTimeControl(txtNgaymophientoa, 'Ngày mở phiên tòa'))
                return false;

            var hddNgayThuLy = document.getElementById('<%=hddNgayThuLy.ClientID%>');
            if (hddNgayThuLy !== null && hddNgayThuLy.value != "") {
                if (!SoSanh2Date(txtNgaymophientoa, "Ngày mở phiên tòa", hddNgayThuLy.value, 'Ngày thụ lý (' + hddNgayThuLy.value + ')'))
                    return false;
            }

            //--------------------
            var txtNgaytuyenan = document.getElementById('<%=txtNgaytuyenan.ClientID%>');
            if (txtNgaytuyenan !== null) {
                if (!CheckDateTimeControl(txtNgaytuyenan, 'Ngày tuyên án'))
                    return false;

                if (!SoSanh2Date(txtNgaytuyenan, 'Ngày tuyên án', txtNgaymophientoa.value, "Ngày mở phiên tòa"))
                    return false;
            }
            //---------------------
            var txtNgayhieuluc = document.getElementById('<%=txtNgayhieuluc.ClientID%>');
            if (txtNgayhieuluc !== null && Common_CheckEmpty(txtNgayhieuluc.value)) {
                if (!CheckDateTimeControl(txtNgayhieuluc, 'Ngày hiệu lực'))
                    return false;

                if (!SoSanh2Date(txtNgayhieuluc, 'Ngày hiệu lực', txtNgaytuyenan.value, "Ngày tuyên án"))
                    return false;
            }

            var rdbVKSThamgia = document.getElementById('<%=rdbVKSThamgia.ClientID%>');
            if (rdbVKSThamgia !== null && !CheckChangeRadioButtonList(rdbVKSThamgia, 'Mục "Có VKS tham gia?" bắt buộc phải chọn. Hãy kiểm tra lại!'))
                return false;
            
            var txtSoQDTraiPL = document.getElementById('<%=txtSoQDTraiPL.ClientID%>');
            if (!Common_CheckEmpty(txtSoQDTraiPL.value)) {
                alert('Bạn chưa nhập "Số quyết định cá biệt trái pháp luật của cơ quan, tổ chức bị Tòa án hủy". Hãy kiểm tra lại!');
                txtSoQDTraiPL.focus();
                return false;
            }

            var txtSoQDTraiPLBiHuy_QD = document.getElementById('<%=txtSoQDTraiPLBiHuy_QD.ClientID%>');
            if (txtSoQDTraiPLBiHuy_QD !== null && !Common_CheckTextBox(txtSoQDTraiPLBiHuy_QD, "Số quyết định cá biệt trái pháp luật của cơ quan, tổ chức bị Tòa án hủy")) {
                return false;
            }
            //Có VKS tham gia?
            var rdbVKSThamgia_QD = document.getElementById('<%=rdbVKSThamgia_QD.ClientID%>');
            if (rdbVKSThamgia_QD !== null && !CheckChangeRadioButtonList(rdbVKSThamgia_QD, 'Mục "Có VKS tham gia?" bắt buộc phải chọn. Hãy kiểm tra lại!'))
                return false;
            //Tòa án tổ chức Hòa giải thành?
            var rdqHoaGiaiThanhQD = document.getElementById('<%=rdqHoaGiaiThanhQD.ClientID%>');
            if (rdqHoaGiaiThanhQD !== null && !CheckChangeRadioButtonList(rdqHoaGiaiThanhQD, 'Mục "Tòa án tổ chức Hòa giải thành?" bắt buộc phải chọn. Hãy kiểm tra lại!'))
                return false;
            //----------------------
            <%--var rdbAnle = document.getElementById('<%=rdbAnle.ClientID%>');
            msg = 'Mục "Có áp dụng Án lệ" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbAnle, msg))
                return false;--%>
            //-------------------------
            var rdbVKSThamgia = document.getElementById('<%=rdbVKSThamgia.ClientID%>');
            msg = 'Mục "Có VKS tham gia" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbVKSThamgia, msg))
                return false;
            //-----------------------------
            var rdVuAnQuaHan = document.getElementById('<%=rdVuAnQuaHan.ClientID%>');
            msg = 'Mục "Vụ án quá hạn luật định" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdVuAnQuaHan, msg))
                return false;
            //-------------------------------
            <%--var rdCongBoBA = document.getElementByID('<%=rdCongboBA.ClientID%>');
            msg = 'Mục "Công bố bản án" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdCongBoBA, msg))
                return false;--%>
            //-------------------------------
            var inputs = rdVuAnQuaHan.getElementsByTagName('input');
            var selected = 0;
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    selected = inputs[i].value;
                    break;
                }
            }
            if (selected == 1) {
                var rdNNChuQuan = document.getElementById('<%=rdNNChuQuan.ClientID%>');
                msg = 'Mục "Nguyên nhân chủ quan" bắt buộc phải chọn. Hãy kiểm tra lại!';
                if (!CheckChangeRadioButtonList(rdNNChuQuan, msg))
                    return false;
                //-----------------------------
                var rdNNKhachQuan = document.getElementById('<%=rdNNKhachQuan.ClientID%>');
                msg = 'Mục "Nguyên nhân khách quan" bắt buộc phải chọn. Hãy kiểm tra lại!';
                if (!CheckChangeRadioButtonList(rdNNKhachQuan, msg))
                    return false;
            }
            //-----------------------------
            return true;
        }
        function uploadComplete(sender) {
            //__doPostBack('tctl00$UpdatePanel1', '');
            __doPostBack('<%= dgFile.UniqueID %>', '');
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
            // CheckKyso();
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
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }

    </script>
    <script type="text/javascript">
        function myFunctionFocus() {
            var cmdTGTT = document.getElementById('<%= cmdTGTT.ClientID%>');
            cmdTGTT.style.marginBottom = "120px";
            window.scrollTo(0, document.body.scrollHeight);
        }
        function DownloadFile(link, fileName) {
            fetch(link)
                .then(res => res.blob())
                .then(blob => {
                    var link = document.createElement('a');
                    link.href = window.URL.createObjectURL(blob, {
                        type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                    });
                    link.download = fileName;
                    link.click();
                });
        }
    </script>
    <script type="text/javascript">
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
