<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KetQuaPhancong.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.PCTP.KetQuaPhancong" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Lịch sử phân công ngẫu nhiên</h4>
                <div class="boder" style="padding: 10px; min-height: 200px;">
                    <table class="table1">
                        <tr>
                            <td class="DonGDTCol1">Người gửi</td>
                            <td class="DonGDTCol2"><asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox> </td>
                            <td class="DonGDTCol3">Số BA/QĐ</td>
                            <td class="DonGDTCol4">
                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="222px" MaxLength="50"></asp:TextBox>
                            </td>
                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                            <td>
                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Tòa ra BA/QĐ</td>
                            <td><asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList></td>
                            <td>Số thụ lý</td>
                            <td>
                                <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                            </td>
                            <td>Ngày thụ lý</td>
                            <td>
                                <asp:TextBox ID="txtThuly_Ngay" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtThuly_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtThuly_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                                <td>Thẩm phán</td>
                                <td><asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="230px"> </asp:DropDownList> </td>
                                <td>Số tờ trình</td>
                                <td>
                                    <asp:TextBox ID="txtSoTotrinh" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                </td>
                                <td>Ngày tờ trình</td>
                                <td>
                                    <asp:TextBox ID="txtTotrinh_ngay" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTotrinh_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTotrinh_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                         </tr>
                           <tr>
                                <td>Phân công từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                               <td>Loại Phân công</td>
                                <td style="width: 230px;">
                                    <asp:DropDownList ID="ddlLaiPhanCong" CssClass="chosen-select" runat="server" Width="230px">
                                        <asp:ListItem Value="10" Text="Tất cả"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Phân công ngẫu nhiên"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Phân công chỉ định"></asp:ListItem>
                                    </asp:DropDownList></td>
                          </tr>
                         <tr>
                                <td>                                                   
                                               
                                </td>
                                <td  align="left" colspan="5">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click"  />
                                        
                                           
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                        <asp:Label ID="Label1" runat="server" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    
                 
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>
                                <asp:Label ID="lblThongbao" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
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
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HinhThucPC" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="115px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SODON" HeaderText="Số lượng đơn" HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Tài khoản thực hiện
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("USERNAME") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                            <HeaderTemplate>
                                                Người thực hiện
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="TUNGAY" HeaderText="Ngày nhận đơn từ" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="DENNGAY" HeaderText="Đến ngày" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Sửa kết quả
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa kết quả" CssClass="grid_button"
                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") + "," + Eval("HinhThucPC") + "," + Eval("LOAI")%>'
                                                        ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                    <span class="tooltiptext  tooltip-bottom">Sửa kết quả</span>
                                                </div>
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdPrint" runat="server" ToolTip="In kết quả" CssClass="grid_button"
                                                    CommandName="In" CommandArgument='<%#Eval("ID") + "," + Eval("HinhThucPC") + "," + Eval("LOAI")%>'
                                                    ImageUrl="~/UI/img/printer-16.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">In kết quả</span>
                                            </div>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Hủy kết quả</HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Hủy phân công thẩm phán" CssClass="grid_button"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") + "," + Eval("HinhThucPC") + "," + Eval("LOAI")%>'
                                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                                        OnClientClick="return confirm('Bạn thực sự muốn hủy kết quả phân công này? ');" />
                                                    <span class="tooltiptext  tooltip-bottom">Hủy phân công thẩm phán</span>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
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
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function popup_in(ID) {
            var link = "/BaoCao/PCTP/ViewReport.aspx?cid=" + ID;
            var width = 1100;
            var height = 700;
            PopupReport(link, "Phân công thẩm phán giải quyết đơn", width, height);
        }
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            //OpenPopUpPage(pageURL, null, w, h);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
</asp:Content>
