<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KhangCaoKhangNghi.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Sotham.KhangCaoKhangNghi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .KCHNCol1 {
            width: 133px;
        }

        .KCHNCol2 {
            width: 305px;
        }

        .KCHNCol3 {
            width: 122px;
        }
        .TenFile_css {
            color: inherit !important;
        }
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddChonDonKC" runat="server" />
    <asp:HiddenField ID="hddChonDonKN" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd" style="width: 99%;">
            <asp:Panel ID="pnKhangCao" runat="server" Visible="true">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin Đề nghị</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKC" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKC_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Đề nghị" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdbHinhThucNhanDon" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Ngày viết đơn </td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKC" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="KCHNCol3">Ngày Đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangcao" runat="server" 
                                          AutoPostBack ="true" OnTextChanged="txtNgaykhangcao_TextChanged"
                                        CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tên người Đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server" Width="98%"  AutoPostBack="True" OnSelectedIndexChanged="ddlNguoikhangcao_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Loại Đề nghị</td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Tuyên bố phá sản"></asp:ListItem>
                                  <asp:ListItem Value="1" Text="QĐ đình chỉ" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="QĐ tạm đình chỉ/khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KC" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KC_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Đề nghị quá hạn <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KC" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQDBA_KC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQDBA_KC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Tòa án ra QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KC" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Nội dung Đề nghị</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKC" runat="server" CssClass="user" Width="99.8%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath_KC" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangCao" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangCao_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                </td>
                                <td>
                                    <asp:LinkButton ID="lbtDownloadKhangCao" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_Click"></asp:LinkButton></td>
                                <td>
                                    <asp:LinkButton ID="lbtDownloadKhangCao_DonKhangCao" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_DonKhangCao_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin tạm ứng án phí phúc thẩm</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Miễn án phí<span class="batbuoc">(*)</span></td>
                                        <td style="width: 305px;">
                                            <asp:RadioButtonList ID="rdbMienAnphi" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbMienAnphi_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td style="width: 115px;">Số biên lai</td>
                                        <td>
                                            <asp:TextBox ID="txtSobienlai" runat="server" CssClass="user" Width="90px" MaxLength="20"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Án phí</td>
                                        <td>
                                            <asp:TextBox ID="txtAnphi" runat="server"
                                                Style="text-align: right; padding-right: 5px;" CssClass="user"
                                                Width="100px"
                                                onkeyup="javascript:this.value=Comma(this.value);"
                                                onkeypress="return isNumber(event)"></asp:TextBox>
                                        </td>
                                        <td>Ngày nộp án phí</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaynopanphi" runat="server" CssClass="user"
                                                onkeypress="return isNumber(event)" Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgaynopanphi" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgaynopanphi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnKhangNghi" runat="server" Visible="false">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kháng nghị</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKN" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKN_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Đề nghị" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tòa án ra QĐ/BA</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtToaAnQD_KN" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 135px;">Người Kháng nghị<span class="batbuoc">(*)</span></td>
                                <td style="width: 250px;">
                                    <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbDonVi_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Chánh án"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Viện trưởng"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 115px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbCapkhangnghi_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Cùng cấp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr id="trDVKN" runat="server" visible="false">
                                <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Số kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtSokhangnghi" runat="server" CssClass="user" Width="242px" MaxLength="20"></asp:TextBox>
                                </td>
                                <td>Ngày kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangnghi" runat="server" CssClass="user"
                                        onkeypress="return isNumber(event)" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>

                                <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKN" runat="server" Width="300px" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="QĐ tuyên bố phá sản"></asp:ListItem>
                                  <asp:ListItem Value="1" Text="QĐ đình chỉ" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="QĐ tạm đình chỉ/khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBAKhangNghi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true"
                                        onkeypress="return isNumber(event)"
                                        Enabled="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td>Nội dung kháng nghị</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKN" runat="server" CssClass="user" Width="100%" TextMode="MultiLine" Height="50px" MaxLength="1000"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath_KN" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangNghi" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangNghi_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                </td>
                                <td>
                                    <asp:LinkButton ID="lbtDownloadKhangNghi" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangNghi_Click"></asp:LinkButton></td>
                                <td>
                                    <asp:LinkButton ID="lbtDownloadKhangNghi_DonKhangCao" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangNghi_DonKhangCao_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidData();" OnClick="btnUpdate_Click" />
                            <asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
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
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Đề nghị, Kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HTNhanDonDonViKN" HeaderText="Hình thức nhận đơn KN, Đơn vị kháng nghị" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người Đề nghị, Cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="118px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày Đề nghị, kháng nghị" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày QĐ/BA" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TINHTRANG_GIAIQUYET"  HeaderText="Tình trạng giải quyết" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                      <%--  <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="94px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>--%>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate >
                                        <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip='<%#Eval("TENFILE")%>' />
                                        <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                     <asp:LinkButton ID="lblchitiet" runat="server" Text="Chi tiết" CausesValidation="false" CommandName="chitiet" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>'></asp:LinkButton>
                                               
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
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
                <div style="display: none">
                    <asp:Button ID="cmdLoadDonKhac" runat="server" Text="Load ds BI don khac" OnClick="cmdLoadDonKhac_Click" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidData() {
            var rdbPanelKC = document.getElementById('<%=rdbPanelKC.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdbPanelKC);
            if (selected_value == 1) {
                if (!validate_khangcao())
                    return false;
            }
            else if (selected_value == 2) {
                if (!validate_khangnghi())
                    return false;
            }
            return true;
        }
        function validate_khangcao() {
            var rdbHinhThucNhanDon = document.getElementById('<%=rdbHinhThucNhanDon.ClientID%>');
            var msg = 'Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbHinhThucNhanDon, msg))
                return false;
            //------------------------------------
            var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKC.ClientID%>');
            if (Common_CheckEmpty(KC_txtNgayvietdon.value)) {
                if (!CheckDateTimeControl(KC_txtNgayvietdon, 'Ngày viết đơn'))
                    return false;
            }
            //------------------------------------
            var KC_txtNgaykhangcao = document.getElementById('<%=txtNgaykhangcao.ClientID%>');
            if (!CheckDateTimeControl(KC_txtNgaykhangcao, 'Ngày Đề nghị'))
                return false;
            //------------------------------------
            var KC_ddlNguoikhangcao = document.getElementById('<%=ddlNguoikhangcao.ClientID%>');
            var val = KC_ddlNguoikhangcao.options[KC_ddlNguoikhangcao.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người đề nghị. Hãy kiểm tra lại!');
                KC_ddlNguoikhangcao.focus();
                return false;
            }
            //------------------------------------
            var rdbLoaiKC = document.getElementById('<%=rdbLoaiKC.ClientID%>');
            if (rdbLoaiKC == "") {
                alert('Bạn chưa chọn loại đề nghị. Hãy kiểm tra lại!');
                return false;
            }
            //------------------------------------
            var ddlSOQDBA_KC = document.getElementById('<%=ddlSOQDBA_KC.ClientID%>');
            val = ddlSOQDBA_KC.options[ddlSOQDBA_KC.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ/BA. Hãy kiểm tra lại!');
                ddlSOQDBA_KC.focus();
                return false;
            }
            //------------------------------------
            var rdbQuahan_KC = document.getElementById('<%=rdbQuahan_KC.ClientID%>');
            msg = 'Bạn chưa chọn mục Đề nghị quá hạn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KC, msg))
                return false;
            //------------------------------------
            var rdbMienAnphi = document.getElementById('<%=rdbMienAnphi.ClientID%>');
            msg = 'Bạn chưa chọn mục miễn án phí. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbMienAnphi, msg))
                return false;
            //------------------------------------
            var txtSobienlai = document.getElementById('<%=txtSobienlai.ClientID%>');
            if (Common_CheckEmpty(txtSobienlai.value)) {
                var length_value = txtSobienlai.value.trim().length;
                if (length_value > 20) {
                    alert('Số biên lai không quá 20 ký tự. Hãy nhập lại!');
                    txtSobienlai.focus();
                    return false;
                }
            }
            //------------------------------------
            var txtNgaynopanphi = document.getElementById('<%=txtNgaynopanphi.ClientID%>');
            if (Common_CheckEmpty(txtNgaynopanphi.value)) {
                if (!CheckDateTimeControl(txtNgaynopanphi, 'Ngày nộp án phí'))
                    return false;
            }
            return true;
        }
        function validate_khangnghi() {
            var txtSokhangnghi = document.getElementById('<%=txtSokhangnghi.ClientID%>');
            if (!Common_CheckEmpty(txtNgaynopanphi.value)) {
                alert('Bạn chưa nhập số kháng nghị. Hãy nhập lại!');
                txtSokhangnghi.focus();
                return false;
            }
            if (txtSokhangnghi.value.length > 20) {
                alert('Số kháng nghị không quá 20 ký tự. Hãy nhập lại!');
                txtSokhangnghi.focus();
                return false;
            }
            //-----------------------------
            var txtNgaykhangnghi = document.getElementById('<%=txtNgaykhangnghi.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangnghi, 'Ngày kháng nghị'))
                return false;
            //-----------------------------
            var rdbCapkhangnghi = document.getElementById('<%=rdbCapkhangnghi.ClientID%>');
            msg = 'Bạn chưa chọn cấp kháng nghị. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbCapkhangnghi, msg))
                return false;
            //-----------------------------
            var rdbLoaiKN = document.getElementById('<%=rdbLoaiKN.ClientID%>');
            if (rdbLoaiKC == "") {
                alert('Bạn chưa chọn loại kháng nghị. Hãy kiểm tra lại!');
                return false;
            }
            //-----------------------------
            var ddlSOQDBAKhangNghi = document.getElementById('<%=ddlSOQDBAKhangNghi.ClientID%>');
            var val = ddlSOQDBAKhangNghi.options[ddlSOQDBAKhangNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ/BA. Hãy chọn lại!');
                ddlSOQDBAKhangNghi.focus();
                return false;
            }
            //-----------------------------
            var txtNoidung = document.getElementById('<%=txtNoidungKN.ClientID%>');
            if (Common_CheckEmpty(txtNgaynopanphi.value)) {
                var noidung_length = txtNoidung.value.trim().length;
                if (noidung_length > 1000) {
                    alert('Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!');
                    txtNoidung.focus();
                    return false;
                }
            }
            return true;
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
        function Loadthongtindon() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDonKhac.ClientID %>").click();
        }
        function popup_loaddonkc_bc(DonID, NGUOIKC) {
            var link = "/QLAN/APS/Sotham/Popup/pChonDonKC.aspx?ID=" + DonID + "&KCID=" + NGUOIKC;
            var width = 800;
            var height = 900;
            PopupCenter(link, "Chọn đơn đề nghị", width, height);
        }
    </script>
</asp:Content>
