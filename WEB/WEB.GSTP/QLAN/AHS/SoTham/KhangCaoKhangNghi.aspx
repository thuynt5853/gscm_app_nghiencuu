<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KhangCaoKhangNghi.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.SoTham.KhangCaoKhangNghi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddChonDonKC" runat="server" />
    <asp:HiddenField ID="hddChonDonKN" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <style type="text/css">
        .KCHNCol1 {
            width: 136px;
        }

        .KCHNCol2 {
            width: 305px;
        }

        .KCHNCol3 {
            width: 125px;
        }
    </style>
    <div class="box">
        <div class="box_nd" style="width: 99%;">
            <asp:Panel ID="pnKhangCao" runat="server" Visible="true">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kháng cáo</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKC" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKC_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Người kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiNguoiKC" runat="server"
                                        RepeatDirection="Horizontal"
                                        AutoPostBack="true" OnSelectedIndexChanged="rdbLoaiNguoiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bị can" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td class="KCHNCol3">Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal"
                                        AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án" Selected="True"></asp:ListItem>
                                      <asp:ListItem Value="1" Text="QĐ đình chỉ" ></asp:ListItem>
                                        <asp:ListItem Value="2" Text="QĐ tạm đình chỉ/khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                <td class="KCHNCol2">
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlNguoikhangcao_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <asp:PlaceHolder ID="plNguoiBiKC" runat="server" Visible="false">
                                    <td>Người bị kháng cáo<span class="batbuoc">(*)</span></td>
                                </asp:PlaceHolder>

                                <td>
                                    <asp:ListBox ID="lbNguoiBiKC" CssClass="chosen-select" runat="server" Width="250px" SelectionMode="Multiple" AutoPostBack="True"></asp:ListBox>
                                    <%--<asp:DropDownList ID="ddlNguoiBiKC" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>--%>
                                </td>
                            </tr>
                            <tr>
                                <%--<td class="KCHNCol1">Ngày viết đơn KC</td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKC" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>--%>
                                <td>Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangcao" runat="server"
                                        AutoPostBack="true" OnTextChanged="txtNgaykhangcao_TextChanged"
                                        CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <asp:Panel ID="PanelIsQDVuAnKC" runat="server" Visible="false">
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbIsQDVuAnKC" OnSelectedIndexChanged="rdbIsQDVuAnKC_SelectedIndexChanged" runat="server" RepeatDirection="Horizontal" AutoPostBack="True">
                                            <asp:ListItem Value="0" Text="QĐ vụ án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="QĐ bị can, bị cáo"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KC" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KC_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KC" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="157px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQDBA_KC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQDBA_KC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tòa án ra QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KC" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Yêu cầu kháng cáo<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:CheckBoxList ID="chkYeuCauKC" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
                                </td>
                            </tr>
                            <tr>
                                <td>Nội dung kháng cáo</td>
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
                            <h4 class="tleboxchung">Thông tin án phí</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Miễn án phí/Không phải nộp án phí</td>
                                        <td colspan="5">
                                            <asp:RadioButtonList ID="rdbMienAnphi" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Số biên lai</td>
                                        <td style="width: 110px;">
                                            <asp:TextBox ID="txtSobienlai" runat="server" CssClass="user" Width="90px" MaxLength="20"></asp:TextBox>
                                        </td>
                                        <td style="width: 50px;">Án phí</td>
                                        <td style="width: 120px;">
                                            <asp:TextBox ID="txtAnphi" runat="server"
                                                Style="text-align: right; padding-right: 5px;"
                                                onkeyup="javascript:this.value=Comma(this.value);"
                                                CssClass="user" Width="100px" onkeypress="return isNumber(event)"></asp:TextBox>
                                        </td>
                                        <td style="width: 100px;">Ngày nộp án phí</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaynopanphi" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
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
                                        <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 135px;">Người kháng nghị<span class="batbuoc">(*)</span></td>
                                <td style="width: 305px;">
                                      <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbDonVi_SelectedIndexChanged">
                                         <asp:ListItem Value="0" Text="Chánh án" ></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Viện trưởng" Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 115px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Cùng cấp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>
                            <tr>
                                <td>Người bị kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:ListBox ID="lbNguoiBiKN" CssClass="chosen-select" runat="server" Width="250px" SelectionMode="Multiple" AutoPostBack="True" OnSelectedIndexChanged="lbNguoiBiKN_SelectedIndexChanged" Height="16px"></asp:ListBox>
                                    <%--<asp:DropDownList ID="ddlNguoiBiKN" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlNguoiBiKN_SelectedIndexChanged"></asp:DropDownList>--%>
                                </td>
                                <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKN" runat="server" Width="300px" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án" Selected="true"></asp:ListItem>
                                          <asp:ListItem Value="1" Text="QĐ đình chỉ" ></asp:ListItem>
                                        <asp:ListItem Value="2" Text="QĐ tạm đình chỉ/khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr id="trDVKN" runat="server" visible="false">
                                <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList></td>
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
                                    <asp:TextBox ID="txtNgaykhangnghi" runat="server" CssClass="user" Width="162px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <asp:Panel ID="PanelIsQDVuAnKN" runat="server" Visible="false">
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbIsQDVuAnKN" OnSelectedIndexChanged="rdbIsQDVuAnKN_SelectedIndexChanged" runat="server" RepeatDirection="Horizontal" AutoPostBack="True">
                                            <asp:ListItem Value="0" Text="QĐ vụ án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="QĐ bị can, bị cáo"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBAKhangNghi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true" Enabled="false" CssClass="user" Width="162px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tòa án ra QĐ/BA</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtToaAnQD_KN" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Yêu cầu kháng nghị<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:CheckBoxList ID="chkYeuCauKN" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
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
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Kháng cáo, Kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo, Cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiBiKC" HeaderText="Người bị kháng cáo, kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="118px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng cáo, kháng nghị" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày QĐ/BA" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                         <asp:BoundColumn DataField="TINHTRANG_GIAIQUYET" HeaderText="Tình trạng giải quyết" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="94px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
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
            var NgaySoSanh = '<%= NgaySoSanh%>';

            var rdbLoaiNguoiKC = document.getElementById('<%=rdbLoaiNguoiKC.ClientID%>');
            var msg = 'Bạn chưa chọn người kháng cáo. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbLoaiNguoiKC, msg))
                return false;

            //-------------------------------
            var rdbLoaiKC = document.getElementById('<%=rdbLoaiKC.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdbLoaiKC);
            var temp = "";
            if (selected_value == "0") {
                //Ban an
                temp = "bản án";
            }
            else if (selected_value == "1") {
                //Quyet dinh
                temp = "quyết định";
            }
            else {
                //Quyet dinh
                temp = "quyết định khác";
            }

            //----------------------------
            var ddlNguoikhangcao = document.getElementById('<%=ddlNguoikhangcao.ClientID%>');
            var val = ddlNguoikhangcao.options[ddlNguoikhangcao.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn tên người kháng cáo. Hãy kiểm tra lại!');
                ddlNguoikhangcao.focus();
                return false;
            }

            //----------------------------
            <%--var txtNgayvietdonKC = document.getElementById('<%=txtNgayvietdonKC.ClientID%>');
            if (Common_CheckEmpty(txtNgayvietdonKC.value)) {
                if (!CheckDateTimeControl(txtNgayvietdonKC, 'Ngày viết đơn'))
                    return false;
                if (!SoSanh2Date(txtNgayvietdonKC, 'Ngày viết đơn', NgaySoSanh, 'Ngày ' + temp))
                    return false;
            }--%>

            //----------------------------
            var txtNgaykhangcao = document.getElementById('<%=txtNgaykhangcao.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangcao, 'Ngày kháng cáo'))
                return false;
            if (!SoSanh2Date(txtNgaykhangcao, 'Ngày kháng cáo', NgaySoSanh, 'Ngày ' + temp))
                return false;


            //----------------------------
            var rdbLoaiKC = document.getElementById('<%=rdbLoaiKC.ClientID%>');
            if (rdbLoaiKC == "") {
                alert('Bạn chưa chọn loại kháng cáo. Hãy kiểm tra lại!');
                return false;
            }

            //----------------------------
            var ddlSOQDBA_KC = document.getElementById('<%=ddlSOQDBA_KC.ClientID%>');
            var val = ddlSOQDBA_KC.options[ddlSOQDBA_KC.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn Số QĐ/BA. Hãy kiểm tra lại!');
                ddlSOQDBA_KC.focus();
                return false;
            }

            //----------------------------
            var rdbQuahan_KC = document.getElementById('<%=rdbQuahan_KC.ClientID%>');
            var msg = 'Bạn chưa chọn mục kháng cáo quá hạn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KC, msg)) {
                return false;
            }

            //----------------------------
            var CHK = document.getElementById("<%=chkYeuCauKC.ClientID%>");
            var checkbox = CHK.getElementsByTagName("input");
            var counter = 0;
            for (var i = 0; i < checkbox.length; i++) {
                if (checkbox[i].checked) {
                    counter++;
                    break;
                }
            }
            if (counter == 0) {
                alert('Bạn chưa chọn yêu cầu kháng cáo. Hãy kiểm tra lại!');
                return false;
            }

            //----------------------------
            var txtSobienlai = document.getElementById('<%=txtSobienlai.ClientID%>');
            if (Common_CheckEmpty(txtSobienlai.value)) {
                var temp_length = txtSobienlai.value.length;
                if (temp_length > 20) {
                    alert('Số biên lai không quá 20 ký tự. Hãy nhập lại!');
                    txtSobienlai.focus();
                    return false;
                }
            }

            //----------------------------
            var txtNgaynopanphi = document.getElementById('<%=txtNgaynopanphi.ClientID%>');
            if (Common_CheckEmpty(txtNgaynopanphi.value)) {
                if (!CheckDateTimeControl(txtNgaynopanphi, 'Ngày nộp án phí'))
                    return false;
            }
            return true;
        }
        function validate_khangnghi() {
            var NgaySoSanh = '<%= NgaySoSanh%>';

            //------------------------------------------
            var rdbCapkhangnghi = document.getElementById('<%=rdbCapkhangnghi.ClientID%>');
            var msg = 'Bạn chưa chọn cấp kháng nghị. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbCapkhangnghi, msg))
                return false;

            //----------------------------------
            var txtSokhangnghi = document.getElementById('<%=txtSokhangnghi.ClientID%>');
            if (!Common_CheckEmpty(txtSokhangnghi.value)) {
                alert('Bạn chưa nhập số kháng nghị. Hãy kiểm tra lại!');
                txtSokhangnghi.focus();
                return false;
            }
            var temp_length = txtSokhangnghi.value.length;
            if (temp_length > 20) {
                alert('Số kháng nghị không quá 20 ký tự. Hãy nhập lại!');
                txtSokhangnghi.focus();
                return false;
            }

            //------------------------------
            var txtNgaykhangnghi = document.getElementById('<%=txtNgaykhangnghi.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangnghi, 'Ngày kháng nghị'))
                return false;
            //if (!SoSanh2Date(CheckDateTimeControl, 'Ngày kháng nghị', NgaySoSanh, 'Ngày ' + temp))
            //    return false;

            //------------------------------------------
            var ddlSOQDBAKhangNghi = document.getElementById('<%=ddlSOQDBAKhangNghi.ClientID%>');
            var val = ddlSOQDBAKhangNghi.options[ddlSOQDBAKhangNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn Số QĐ/BA. Hãy kiểm tra lại!');
                ddlSOQDBAKhangNghi.focus();
                return false;
            }

            //------------------------------------------
            var txtNoidung = document.getElementById('<%=txtNoidungKN.ClientID%>');
            if (Common_CheckEmpty(txtNoidung.value)) {
                temp_length = txtNoidung.value.length;
                if (temp_length > 1000) {
                    alert('Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!');
                    txtNoidung.focus();
                    return false;
                }
            }

            //---------------------------
            var chkYeuCauKN = document.getElementById("<%=chkYeuCauKN.ClientID%>");
            var checkboxKN = chkYeuCauKN.getElementsByTagName("input");
            var counterKN = 0;
            for (var i = 0; i < checkboxKN.length; i++) {
                if (checkboxKN[i].checked) {
                    counterKN++;
                    break;
                }
            }
            if (counterKN == 0) {
                alert('Bạn chưa chọn yêu cầu kháng nghị. Hãy kiểm tra lại!');
                return false;
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
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function Loadthongtindon() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDonKhac.ClientID %>").click();
        }
        function popup_loaddonkc_bc(DonID, NGUOIKC) {
            var link = "/QLAN/AHS/Sotham/BanAnST/Popup/pChonDonKC.aspx?ID=" + DonID + "&KCID=" + NGUOIKC;
            var width = 800;
            var height = 900;
            PopupCenter(link, "Chọn đơn kháng cáo", width, height);
        }
    </script>

</asp:Content>
