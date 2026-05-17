<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="DanhSachCA.aspx.cs" Inherits="WEB.GSTP.QLAN.BAOCAOCA.DanhSachCA" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hdd_INBC" Value="0" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }

        .full_width {
            float: left;
            width: 100%;
        }

        .link_view {
            color: #0e7eee;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                
                                                    <asp:RequiredFieldValidator 
                                                        ID="rfvThuly_Tu" 
                                                        runat="server" 
                                                        ControlToValidate="txtThuly_Tu" 
                                                        ErrorMessage="Vui lòng nhập từ ngày!" 
                                                        ForeColor="Red" 
                                                        Display="Dynamic" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                
                                                    <asp:RequiredFieldValidator 
                                                        ID="rfvThuly_Den" 
                                                        runat="server" 
                                                        ControlToValidate="txtThuly_Den" 
                                                        ErrorMessage="Vui lòng nhập đến ngày!" 
                                                        ForeColor="Red" 
                                                        Display="Dynamic" />
                                                </td>
                                                <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Thẩm phán</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="display:none">
                                                    <asp:Literal ID="lttYKienKetLuan" runat="server">Ý kiến tờ trình</asp:Literal>
                                                </td>
                                                <td style="display:none">
                                                    <asp:DropDownList ID="dropIsYKienKetLuatTrinhLD"
                                                        CssClass="chosen-select" runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropIsYKienKetLuatTrinhLD_SelectedIndexChanged">
                                                        <asp:ListItem Value="2" Text="---Tất cả---"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text="... Trả lời đơn"></asp:ListItem>
                                                        <asp:ListItem Value="11" Text="... Kháng nghị"></asp:ListItem>
                                                        <asp:ListItem Value="12" Text="... Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="13" Text="... Xác minh, BS"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="... Yêu cầu trình tiếp"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Án thời hiệu</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB_TH" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="" Text="--- Tất cả ---"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Đã hết thời hiệu"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Còn thời hiệu dưới một tháng"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Còn thời hiệu dưới hai tháng"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Còn thời hiệu dưới ba tháng"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="Còn thời hiệu dưới sáu tháng"></asp:ListItem>
                                                        <asp:ListItem Value="55" Text="Còn thời hiệu dưới 5 năm"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Kết quả thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                                        runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Kết quả xét xử</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Thuộc án</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropAnDB_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Án 8.1"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Án 9.3"></asp:ListItem>
                                                        <asp:ListItem Value="99" Text="Án 8.1 và 9.3"></asp:ListItem>
                                                        <%--<asp:ListItem Value="2" Text="Án Chỉ đạo"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Người gửi đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtNguoiguidon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <asp:Panel ID="pnSearchCC" runat="server" Visible="false">
                                                <tr>

                                                    <td>
                                                        <asp:DropDownList runat="server" ID="dropLoaiNgaySer"
                                                            Width="120px" CssClass="chosen-select">
                                                            <asp:ListItem Value="1" Selected="True" Text="Ngày Bản án"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Ngày có Hồ sơ"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Ngày phân TTV"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>Từ
                                                        <asp:TextBox ID="txtNgayBA_Tu" runat="server" CssClass="user" Width="205px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBA_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBA_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Đến ngày</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayBA_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBA_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBA_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                            </asp:Panel>
                                        </asp:Panel>

                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lbBack_Click" Style="margin-left:63px;"/>
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" Visible="false"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" EnableViewState="true"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtSTT" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtSoNgayThuLy" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtThongTinBanAn" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate >Quan hệ pháp luật</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtQHPL" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Nguyên đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtNguyenDon" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Bị đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtBiDon" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate >Tội danh</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtToiDanh" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Bị cáo đầu vụ</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtBCDV" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Bị cáo khác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtBCK" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người đề nghị</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtNguoiKhieuNai" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án quốc hội, có ý kiến lãnh đạo đảng nhà nước
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="txtAnQuocHoi" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="130px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                        <ItemTemplate>
                                           <asp:Literal ID="txtThamPhan" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>

                                            <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <a href="javascript:;" class="link_view" onclick='ViewVuAn(<%#Eval("ID") %>, <%#Eval("LoaiAn") %>)'>Thông tin vụ án</a>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>

                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function PopupReport(pageURL, title, w, h) {
            //alert(pageURL);
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function ViewVuAn(vuan_id, loaian) {
            //  alert(vuan_id);
            var pageURL = '';
            //if (loaian != 1)
            pageURL = '/QLAN/BAOCAOCA/Popup/ThongTinVAMHCA.aspx?vid=' + vuan_id;
            //else
            //    pageURL = '/QLAN/BAOCAOCA/PopupBaoCaoCA/ThongTinVAHSBCCA.aspx?vid=' + vuan_id;
            var title = 'Thông tin vụ án';
            var w = 1000;
            var h = 400;
            PopupReport(pageURL, title, w, h);
        }
        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
