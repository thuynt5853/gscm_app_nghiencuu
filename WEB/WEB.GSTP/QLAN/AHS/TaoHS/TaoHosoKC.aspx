<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="TaoHosoKC.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.TaoHS.TaoHosoKC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHS/TaoHS/Popup/uDSBiCao.ascx" TagPrefix="uc1" TagName="uDSBiCao" %>
<%@ Register Src="~/QLAN/AHS/TaoHS/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBAQDID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCaoID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddCaoTrangID" runat="server" Value="0" />
    <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
    <asp:HiddenField ID="hddKCID" runat="server" Value="0" />
    <asp:HiddenField ID="hddKNID" runat="server" Value="0" />
    <!------------------------------------------->
    <!------------------------------------------->

    <style>
        .button_right { 
            float: right;
            text-align: center;
            margin-left: 10px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                   
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                    </div>
                
                    <!--------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin Hồ sơ KC/KN</h4>
                        <div class="boder" style="padding: 5px 10px;">
                             <table style="border-width: 0;border-collapse: collapse;border-spacing: 0; margin: 0px;padding: 0px;
                             font-size: 12px; font-family: Arial;">
                                <tr style="height:30px">
                                    <td style="width: 145px;">Loại</td>
                                    <td style="width: 500px; padding-right:10px">  
                                        <asp:RadioButtonList ID="rdbLoaiBAQD" runat="server" AutoPostBack="True"  RepeatDirection="Horizontal"
                                            OnSelectedIndexChanged="rdbLoaiBAQD_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Quyết định"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                 </tr>
                            <asp:Panel ID="pnQD" Visible="false" runat="server">
                                <tr  style="height:30px">
                                    <td style="width: 145px;">Tên Quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="True">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                          
                                
                                <tr  style="height:30px">
                                    <td  style="width: 145px;">Số Quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px; padding-right:10px;">
                                        <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="100" MaxLength="20"></asp:TextBox> 
                                    </td>
                                    <td style="width: 115px;" class="QDVACol3">Ngày quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                              </asp:Panel>
                              <asp:Panel ID="pnBanan" Visible="true" runat="server">
                                    <tr style="height:30px">
                                        <td style="width: 145px;">Số Bản án Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;  padding-right:10px;">
                                            <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td style="width: 115px;">Ngày Bản án Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA" AutoPostBack="true" runat="server" CssClass="user"
                                                Width="95px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                                    <tr style="height:30px">
                                        <td style="width: 145px;">Tòa án Xét xử Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="text-align:left">
                                            <asp:DropDownList ID="ddlToaxxST" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="true">
                                            </asp:DropDownList>
                                        </td>
                            
                                    </tr>
                              </table>

                            <%--  --%>

                            <table>
                                
                                <tr style="height:30px">
                                    <td style="width: 145px;">Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px; padding-right:10px;">
                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị cáo đầu vụ - tội danh"
                                            runat="server" Width="250px"></asp:TextBox>
                                    </td>
                                    <td style="width: 115px;">Số bút lục Hồ sơ</td>
                                    <td style="width: 280px;">
                                        <asp:TextBox ID="txtSoButLuc" CssClass="user"  runat="server" Width="100px"></asp:TextBox>
                                    </td>
                                   </tr>
                                <tr style="height:30px">
                                    <td style="width: 145px;">Người nhận Hồ sơ<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px; padding-right:10px;">
                                        <asp:DropDownList ID="ddlNguoinhanHS"  CssClass="chosen-select" Width="260px"  runat="server" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">Ngày nhận Hồ sơ<span class="batbuoc">(*)</span></td>
                                    <td style="width: 100px;">
                                        <asp:TextBox ID="txtNgayNhanHS" runat="server" AutoPostBack ="true" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr style="height:30px">
                                    <td style="width: 145px;">Trường hợp thụ lý Phúc thẩm<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px; padding-right:10px;">
                                        <asp:DropDownList ID="ddlThuly"  CssClass="chosen-select" Width="260px"  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlThuly_SelectedIndexChanged">
                                            <asp:ListItem Text="Do có KC/KN" Value="0" />
                                            <asp:ListItem Text="Thụ lý lại xét xử PT" Value="1" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                   
                    <!-------------------------------->
                    <asp:Panel ID="pnToiDanhChung" runat="server" Visible="true">
                        <div class="boxchung">
                            <h4 class="tleboxchung bg_title_group">Tội danh áp dụng cho các bị cáo</h4>
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
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách bị cáo</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemBiCao" runat="server"
                                OnClick="lkThemBiCao_Click" OnClientClick="return validate();"
                                CssClass="buttonpopup them_user">Thêm bị cáo</asp:LinkButton>
                            <uc1:uDSBiCao runat="server" ID="uDSBiCao" />
                        </div>
                    </div>

                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách người tham gia tố tụng</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemNguoiTGTT" runat="server"
                                OnClick="lkThemNguoiTGTT_Click" OnClientClick="return validate();"
                                CssClass="buttonpopup them_user">Thêm người tham gia tố tụng</asp:LinkButton>

                            <uc1:uDSNguoiThamGiaToTung runat="server" ID="uDSNguoiThamGiaToTung" />
                        </div>
                    </div>
                <div style="margin: 5px; text-align: center; width: 95%;">
                    <asp:Button ID="cmdUpdateVuAnB" runat="server" CssClass="buttoninput"
                        Text="Lưu Hồ sơ" OnClientClick="return validate_all();" OnClick="cmdUpdateVuAn_Click" />
                   
                </div>
                   
                <%-- thong tin Khang cao Kháng nghị --%>
            <asp:Panel ID="pnKhangCao" runat="server" Visible="true">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kháng cáo/kháng nghị</h4>
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
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdbLoaiNguoiKC" runat="server"
                                        RepeatDirection="Horizontal"
                                        AutoPostBack="true"  OnSelectedIndexChanged="rdbLoaiNguoiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bị cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Khác"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                <td class="KCHNCol2">
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                </td>
                                <td class="KCHNCol3">Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal"
                                        AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Quyết định"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                
                                <td>Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangcao" runat="server" AutoPostBack ="true" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"  Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
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
                                    <asp:RadioButtonList ID="rdbPanelKN" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKN_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 135px;">Người kháng nghị<span class="batbuoc">(*)</span></td>
                                <td style="width: 305px;">
                                    <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Chánh án" ></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Viện trưởng" Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 115px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Cùng cấp"  Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>
                            <tr id="trDVKN" runat="server" visible="false">
                                <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select" 
                                        runat="server" Width="250px"></asp:DropDownList></td>
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
                            <tr>

                                <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKN" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án" Selected="true"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Quyết định"></asp:ListItem>
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
                                    <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true" Enabled="false" CssClass="user" Width="162px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
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
                                <td>Nội dung kháng nghị<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKN" runat="server" CssClass="user" Width="100%" TextMode="MultiLine" Height="50px" MaxLength="1000"></asp:TextBox>
                                </td>
                            </tr>
                                                    
                        </table>
                    </div>
                </div>
              </asp:Panel>
            <asp:Panel ID="lastPanel" runat="server">
                <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" Text="Lưu KC/KN" OnClientClick="return ValidData();" OnClick="btnUpdate_Click" />
                            <%--<asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                               
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
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Kháng cáo, Kháng nghị" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo, Cấp kháng nghị" HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SONGAY_BAQD" HeaderText="Số, ngày BA/QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng cáo, kháng nghị" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENYEUCAU" HeaderText="Yêu cầu kháng cáo, kháng nghị" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAONGAYTAO" HeaderText="Người tạo/ Ngày tạo" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>                                        
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                               
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
              </asp:Panel>
                <%--  End --%>
                
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                </div> 
                <div style="margin: 5px; text-align: center; width: 100%">
                        <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                            Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click"
                            OnClientClick="return validate_all();" />
                    
                <%-- Tạm thời ngắt nút xoá, vì Nếu phân quyền "XEM" thì vẫn có quyền xoá
                    Và nếu Toà phúc thẩm có quyền xem thì cũng có quyền xoá, dẫn đến việc mất dữ liệu của toà cấp sơ thẩm
                    01/11/2024--%>
                        <asp:Button ID="cmXoa" runat="server" CssClass="buttoninput" Visible="false"
                            Text="Xóa Hồ sơ" OnClientClick="return confirm('Bạn thực sự muốn xóa Hồ sơ này? ');" OnClick="cmXoa_Click" />
              </div>
            </div>
           
        </div>
    </div>
    <div style="display: none">
        <asp:Button ID="cmdLoadDsBiDonKhac" runat="server"
            Text="Load ds BI don khac" OnClick="cmdLoadDsBiDonKhac_Click" />
        <asp:Button ID="cmdLoadDsNguoiTGTT" runat="server"
            Text="Load ds nguoi TGTT" OnClick="cmdLoadDsNguoiTGTT_Click" />
    </div>
    <script>
        function LoadDsBiCan() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
        }
        function LoadDsNguoiThamGiaTT() {
            //alert('ds nguoi tham gia tt form parent');
            $("#<%= cmdLoadDsNguoiTGTT.ClientID %>").click();
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
        }
    </script>


    <script>
        function validate() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            return true;
        }
        function validate_all() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            //---------------------
            if (!validate_baqd())
                return false;
            return true;
        }

        function validate_thongtinhoso() {
            //-----------------------------
            if (!validate_baqd())
                return false;
           
            //-----------------------------
            var txtTenVuAn = document.getElementById('<%=txtTenVuAn.ClientID%>');
            if (!Common_CheckEmpty(txtTenVuAn.value)) {
                alert('Bạn chưa nhập tên vụ án!');
                txtTenVuAn.focus();
                return false;
            }
             //-----------------------------
            var ddlToaXXST = document.getElementById('<%=ddlToaxxST.ClientID%>');
            var value_change = ddlToaXXST.options[ddlToaXXST.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn Tòa xét xử Sơ thẩm. Hãy kiểm tra lại!');
                ddlToaXXST.focus();
                return false;
            }
            //-----------------------------
            <%--var txtSoButLuc = document.getElementById('<%=txtSoButLuc.ClientID%>');
            if (!Common_CheckEmpty(txtSoButLuc.value)) {
                alert('Bạn chưa nhập Số bút lục!');
                txtSoButLuc.focus();
                return false;
            }--%>
            //-----------------------------
            var ddlNguoinhanHS = document.getElementById('<%=ddlNguoinhanHS.ClientID%>');
            var value_change = ddlNguoinhanHS.options[ddlNguoinhanHS.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn Người nhận Hồ sơ. Hãy kiểm tra lại!');
                ddlNguoinhanHS.focus();
                return false;
            }
            //-----------------------------
            var txtNgayNhanHS = document.getElementById('<%=txtNgayNhanHS.ClientID%>');
            if (!Common_CheckEmpty(txtNgayNhanHS.value)) {
                alert('Bạn chưa nhập ngày nhận hồ sơ!');
                txtNgayNhanHS.focus();
                return false;
            }
            //-----------------------------

            return true;
        }

        function validate_thongtin_vuan() {
            return true;
        }

        function validate_baqd() {
            var rdBAQD = document.getElementById('<%=rdbLoaiBAQD.ClientID%>');
            msg = 'Mục "Thông tin Bản án/Quyết định" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            //alert(rdBAQD);
            if (!CheckChangeRadioButtonList(rdBAQD, msg))
                return false;
            var selected_value = GetStatusRadioButtonList(rdBAQD);
            if (selected_value == 1) {
                //-----------------------------
                var txtNgaymophientoa = document.getElementById('<%=txtNgayBA.ClientID%>');
                if (!CheckDateTimeControl(txtNgaymophientoa, 'Ngày Bản án'))
                    return false;
                var txtSobanan = document.getElementById('<%=txtSobanan.ClientID%>');
                    if (!Common_CheckEmpty(txtSobanan.value)) {
                        alert('Bạn chưa nhập số Bản án.Hãy kiểm tra lại!');
                        txtSobanan.focus();
                        return false;
                    }
                //-----------------------------
            
            } else {
                //-----------------------------
                var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
                    if (!Common_CheckEmpty(txtSoQD.value)) {
                        alert('Bạn chưa nhập số Quyết định.Hãy kiểm tra lại!');
                        txtSoQD.focus();
                        return false;
                    }
                var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
                if (!CheckDateTimeControl(txtNgayQD, 'Ngày Quyết định'))
                    return false;
                
                //-----------------------------
            }  
            return true;
        }
    </script>
    <script>
        function popup_them_bc(VuAnID) {
            var link = "/QLAN/AHS/TaoHS/popup/pBiCao.aspx?hsID=" + VuAnID;
            var width = 850;
            var height = 1000;
            PopupCenter(link, "Cập nhật thông tin bị cáo", width, height);
        }
        function popup_them_NguoiTGTT(VuAnID) {
            var link = "/QLAN/AHS/TaoHS/Popup/pNguoiThamGiaTT.aspx?hsID=" + VuAnID;
            var width = 850;
            var height = 650;
            PopupCenter(link, "Người tham gia đối tượng", width, height);
        }
        function popupCaoTrang() {
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var link = "/QLAN/AHS/TaoHS/popup/pCaoTrang.aspx?hsID=" + hddVuAnID.value
            var width = 950;
            var height = 550;
            PopupCenter(link, "Cáo trạng", width, height);
        }
        function popupDieuLuatAD() {
            var width = 950;
            var height = 550;
            var hddCaoTrangID = document.getElementById('<%=hddCaoTrangID.ClientID%>');
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var hddBiCaoID = document.getElementById('<%=hddBiCaoID.ClientID%>');
            var link = "/QLAN/AHS/TaoHS/popup/pChonToiDanh.aspx?hsID=" + hddVuAnID.value + "&bID=" + hddBiCaoID.value;
            PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
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

</asp:Content>



