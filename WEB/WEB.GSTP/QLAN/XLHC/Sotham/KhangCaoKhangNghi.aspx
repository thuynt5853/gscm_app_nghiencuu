<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KhangCaoKhangNghi.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Sotham.KhangCaoKhangNghi" EnableViewState="true"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
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
    <div class="box">
        <div class="box_nd" style="width: 99%;">
            <asp:Panel ID="pnKhieuNai" runat="server" Visible="true">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin khiếu nại</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKhieuNai" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKhieuNai_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Khiếu nại" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kiến nghị"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Kháng nghị"></asp:ListItem>
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
                                <td class="KCHNCol1">Ngày viết đơn khiếu nại</td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKC" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="KCHNCol3">Ngày khiếu nại<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangcao" runat="server"
                                        CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Người khiếu nại<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server" Width="98%"></asp:DropDownList>
                                </td>
                                <td>Khiếu nại quá hạn</td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <tr>
                                <td>Số QĐ<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KC" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KhieuNai_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Tòa án ra QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KC" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KC" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQDBA_KC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQDBA_KC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>

                            </tr>
                            <tr>
                                <td>Nội dung khiếu nại</td>
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
                                <td colspan="2">
                                    <asp:LinkButton ID="lbtDownloadKhangCao" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnKienNghi" runat="server" Visible="false">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kiến nghị</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKienNghi" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKienNghi_SelectedIndexChanged">
                                         <asp:ListItem Value="1" Text="Khiếu nại" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kiến nghị"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdbHinhThucNhanDonKienNghi" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Ngày viết đơn kiến nghị</td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKienNghi" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayvietdonKienNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayvietdonKienNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="KCHNCol3">Ngày kiến nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayKienNghi" runat="server"
                                        CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayKienNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayKienNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>CQ đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoiKienNghi" CssClass="chosen-select" runat="server" Width="98%"></asp:DropDownList>
                                </td>
                                <td>Kiến nghị quá hạn</td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KienNghi" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <tr>
                                <td>Số QĐ<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KienNghi" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KienNghi_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Tòa án ra QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KienNghi" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KienNghi" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayQDBA_KienNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayQDBA_KienNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>

                            </tr>
                            <tr>
                                <td>Nội dung kiến nghị</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKienNghi" runat="server" CssClass="user" Width="99.8%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath_KienNghi" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadKienNghi" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKienNghi_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton ID="lbtDownloadKienNghi" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
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
                                    <asp:RadioButtonList ID="rdbPanelKhangNghi" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKhangNghi_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Khiếu nại" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kiến nghị"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdbHinhThucNhanDonKhangNghi" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Ngày viết đơn kháng nghị</td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKhangNghi" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayvietdonKhangNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayvietdonKhangNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="KCHNCol3">Ngày kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayKhangNghi" runat="server"
                                        CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayKhangNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayKhangNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>VKS cùng cấp<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoiKhangNghi" CssClass="chosen-select" runat="server" Width="98%"></asp:DropDownList>
                                </td>
                                <td>Kháng nghị quá hạn</td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KhangNghi" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <tr>
                                <td>Số QĐ<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KhangNghi" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Tòa án ra QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KhangNghi" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KhangNghi" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayQDBA_KhangNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayQDBA_KhangNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>

                            </tr>
                            <tr>
                                <td>Nội dung kháng nghị</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKhangNghi" runat="server" CssClass="user" Width="99.8%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath_KhangNghi" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangNghi" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangNghi_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton ID="lbtDownloadKhangNghi" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_Click"></asp:LinkButton></td>
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
                                            <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>

                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Khiếu nại, kiến nghị, Kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HTNhanDonDonViKN" HeaderText="Hình thức nhận đơn" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người khiếu nại, CQ đề nghị,VKS cùng cấp" HeaderStyle-Width="210px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="tenquyetdinh" HeaderText="Tên quyết định" HeaderStyle-Width="220px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày khiếu nại, kháng nghị" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số QĐ" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày QĐ" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="94px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <%-- <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip='<%#Eval("TENFILE")%>' />
                                                <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
        function ValidData() {
            var rdbPanelKC = document.getElementById('<%=rdbPanelKhieuNai.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdbPanelKC);
            if (selected_value == 1) {
                if (!validate_khangcao())
                    return false;
            }
            else if (selected_value == 2) {
                if (!validate_kiennghi())
                    return false;
            }
            else if (selected_value == 3) {
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
           <%-- var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKC.ClientID%>');
            if (Common_CheckEmpty(KC_txtNgayvietdon.value)) {
                if (!CheckDateTimeControl(KC_txtNgayvietdon, 'Ngày viết đơn'))
                    return false;
            }
            //------------------------------------
            var KC_txtNgaykhangcao = document.getElementById('<%=txtNgaykhangcao.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangcao, 'Ngày khiếu nại'))
                return false;
            //--------------------------------------%>
            var KC_ddlNguoikhangcao = document.getElementById('<%=ddlNguoikhangcao.ClientID%>');
            var val = KC_ddlNguoikhangcao.options[KC_ddlNguoikhangcao.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người kháng cáo. Hãy kiểm tra lại!');
                KC_ddlNguoikhangcao.focus();
                return false;
            }
            var ddlSOQDBA_KC = document.getElementById('<%=ddlSOQDBA_KC.ClientID%>');
            val = ddlSOQDBA_KC.options[ddlSOQDBA_KC.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ. Hãy kiểm tra lại!');
                ddlSOQDBA_KC.focus();
                return false;
            }
            //------------------------------------

            var rdbQuahan_KC = document.getElementById('<%=rdbQuahan_KC.ClientID%>');
            msg = 'Bạn chưa chọn mục khiếu nại quá hạn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KC, msg))
                return false;

            return true;
        }

        function validate_kiennghi() {
            var rdbHinhThucNhanDon = document.getElementById('<%=rdbHinhThucNhanDon.ClientID%>');
            var msg = 'Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbHinhThucNhanDon, msg))
                return false;
            //------------------------------------
            var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKienNghi.ClientID%>');
            if (Common_CheckEmpty(KC_txtNgayvietdon.value)) {
                if (!CheckDateTimeControl(KC_txtNgayvietdon, 'Ngày viết đơn'))
                    return false;
            }
            //------------------------------------
            var KC_txtNgayKienNghi = document.getElementById('<%=txtNgayKienNghi.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangcao, 'Ngày khiếu nại'))
                return false;
            //------------------------------------
            var KC_ddlNguoiKienNghi = document.getElementById('<%=ddlNguoiKienNghi.ClientID%>');
            var val = KC_ddlNguoiKienNghi.options[KC_ddlNguoiKienNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người kháng cáo. Hãy kiểm tra lại!');
                KC_ddlNguoiKienNghi.focus();
                return false;
            }
            var ddlSOQDBA_KienNghi = document.getElementById('<%=ddlSOQDBA_KienNghi.ClientID%>');
            val = ddlSOQDBA_KienNghi.options[ddlSOQDBA_KienNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ. Hãy kiểm tra lại!');
                ddlSOQDBA_KienNghi.focus();
                return false;
            }
            //------------------------------------

            var rdbQuahan_KienNghi = document.getElementById('<%=rdbQuahan_KienNghi.ClientID%>');
            msg = 'Bạn chưa chọn mục khiếu nại quá hạn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KienNghi, msg))
                return false;

            return true;
        }

        function validate_khangnghi() {
            var rdbHinhThucNhanDon = document.getElementById('<%=rdbHinhThucNhanDonKhangNghi.ClientID%>');
            var msg = 'Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbHinhThucNhanDon, msg))
                return false;
            //------------------------------------
            var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKhangNghi.ClientID%>');
            if (Common_CheckEmpty(KC_txtNgayvietdon.value)) {
                if (!CheckDateTimeControl(KC_txtNgayvietdon, 'Ngày viết đơn'))
                    return false;
            }
            //------------------------------------
            var KC_txtNgayKhangNghi = document.getElementById('<%=txtNgayKhangNghi.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangcao, 'Ngày khiếu nại'))
                return false;
            //------------------------------------
            var KC_ddlNguoiKhangNghi = document.getElementById('<%=ddlNguoiKhangNghi.ClientID%>');
            var val = KC_ddlNguoiKhangNghi.options[KC_ddlNguoiKhangNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người kháng cáo. Hãy kiểm tra lại!');
                KC_ddlNguoiKhangNghi.focus();
                return false;
            }
            var ddlSOQDBA_KhangNghi = document.getElementById('<%=ddlSOQDBA_KhangNghi.ClientID%>');
            val = ddlSOQDBA_KhangNghi.options[ddlSOQDBA_KhangNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ. Hãy kiểm tra lại!');
                ddlSOQDBA_KhangNghi.focus();
                return false;
            }
            //------------------------------------

            var rdbQuahan_KhangNghi = document.getElementById('<%=rdbQuahan_KhangNghi.ClientID%>');
            msg = 'Bạn chưa chọn mục khiếu nại quá hạn. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KhangNghi, msg))
                return false;

            return true;
        }

       <%-- function ValidData() {
            if (document.getElementById('<%=pnKhangCao.ClientID%>')) {
                var rdbHinhThucNhanDon = document.getElementById('<%=rdbHinhThucNhanDon.ClientID%>');
                var msg = 'Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdbHinhThucNhanDon, msg))
                    return false;
                var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKC.ClientID%>');
                if (KC_txtNgayvietdon.value.trim().length > 0) {
                    var arr = KC_txtNgayvietdon.value.split('/');
                    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                        alert('Bạn phải nhập ngày viết đơn theo định dạng (dd/MM/yyyy).');
                        KC_txtNgayvietdon.focus();
                        return false;
                    }
                }
                var KC_txtNgaykhangcao = document.getElementById('<%=txtNgaykhangcao.ClientID%>');
                var lengthNgaykhangcao = KC_txtNgaykhangcao.value.trim().length;
                if (lengthNgaykhangcao == 0) {
                    alert('Bạn chưa nhập ngày khiếu nại.');
                    KC_txtNgaykhangcao.focus();
                    return false;
                }
                if (lengthNgaykhangcao > 0) {
                    var arr = KC_txtNgaykhangcao.value.split('/');
                    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                        alert('Bạn phải nhập ngày khiếu nại theo định dạng (dd/MM/yyyy).');
                        KC_txtNgaykhangcao.focus();
                        return false;
                    }
                }
                var KC_ddlNguoikhangcao = document.getElementById('<%=ddlNguoikhangcao.ClientID%>');
                var val = KC_ddlNguoikhangcao.options[KC_ddlNguoikhangcao.selectedIndex].value;
                if (val == 0) {
                    alert('Bạn chưa chọn người khiếu nại. Hãy chọn lại!');
                    KC_ddlNguoikhangcao.focus();
                    return false;
                }
                var rdbLoaiKC = document.getElementById('<%=rdbLoaiKC.ClientID%>');
                msg = 'Bạn chưa chọn loại khiếu nại. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdbLoaiKC, msg))
                    return false;
                var ddlSOQDBA_KC = document.getElementById('<%=ddlSOQDBA_KC.ClientID%>');
                var val = ddlSOQDBA_KC.options[ddlSOQDBA_KC.selectedIndex].value;
                if (val == 0) {
                    alert('Bạn chưa chọn số QĐ/BA. Hãy chọn lại!');
                    ddlSOQDBA_KC.focus();
                    return false;
                }
                var rdbQuahan_KC = document.getElementById('<%=rdbQuahan_KC.ClientID%>');
                msg = 'Bạn chưa chọn khiếu nại quá hạn. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdbQuahan_KC, msg))
                    return false;
                
            }
            else {
                var txtSokhangnghi = document.getElementById('<%=txtSokhangnghi.ClientID%>');
                var lengthSoKN = txtSokhangnghi.value.trim().length;
                if (lengthSoKN == 0) {
                    alert('Bạn chưa nhập số kháng nghị. Hãy nhập lại!');
                    txtSokhangnghi.focus();
                    return false;
                } else if (lengthSoKN > 20) {
                    alert('Số kháng nghị không quá 20 ký tự. Hãy nhập lại!');
                    txtSokhangnghi.focus();
                    return false;
                }
                var txtNgaykhangnghi = document.getElementById('<%=txtNgaykhangnghi.ClientID%>');
                var lengthNgaykhangNghi = txtNgaykhangnghi.value.trim().length;
                if (lengthNgaykhangNghi == 0) {
                    alert('Bạn chưa nhập ngày kháng nghị.');
                    txtNgaykhangnghi.focus();
                    return false;
                }
                if (lengthNgaykhangNghi > 0) {
                    var arr = txtNgaykhangnghi.value.split('/');
                    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                        alert('Bạn phải nhập ngày kháng nghị theo định dạng (dd/MM/yyyy).');
                        txtNgaykhangnghi.focus();
                        return false;
                    }
                }
                var rdbCapkhangnghi = document.getElementById('<%=rdbCapkhangnghi.ClientID%>');
                msg = 'Bạn chưa chọn cấp kháng nghị. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdbCapkhangnghi, msg))
                    return false;
                var rdbLoaiKN = document.getElementById('<%=rdbLoaiKN.ClientID%>');
                msg = 'Bạn chưa chọn loại kháng nghị. Hãy chọn lại!';
                if (!CheckChangeRadioButtonList(rdbLoaiKN, msg))
                    return false;
                var ddlSOQDBAKhangNghi = document.getElementById('<%=ddlSOQDBAKhangNghi.ClientID%>');
                var val = ddlSOQDBAKhangNghi.options[ddlSOQDBAKhangNghi.selectedIndex].value;
                if (val == 0) {
                    alert('Bạn chưa chọn số QĐ/BA. Hãy chọn lại!');
                    ddlSOQDBAKhangNghi.focus();
                    return false;
                }
                var txtNoidung = document.getElementById('<%=txtNoidungKN.ClientID%>');
                if (txtNoidung.value.trim().length > 1000) {
                    alert('Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!');
                    txtNoidung.focus();
                    return false;
                }
            }
            return true;
        }--%>
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
</asp:Content>
