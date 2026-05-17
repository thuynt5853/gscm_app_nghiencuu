<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QL_GuiDKK.aspx.cs" Inherits="WEB.GSTP.QTDKK.QLNhanVBTongDat.QL_GuiDKK" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td>
                            <div style="float: left; width: 1050px">
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Chọn đơn vị</div>
                                <div style="float: left;">
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="535px">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div style="float: left; width: 1050px; margin-top: 8px;">
                                <div style="float: left; margin-left: 91px;">
                                    <asp:CheckBox ID="check_child" runat="server" Text="Bao gồm cả các đơn vị cấp dưới." Checked="false" />
                                </div>
                            </div>
                            <div style="float: left; width: 1050px; margin-top: 8px;">
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên người gửi</div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_TENNGUOIGUI" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ việc</div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_MAVUVIEC" CssClass="user" runat="server" Width="184px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="float: left; width: 1050px; margin-top: 8px;">
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Diện thoại</div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_MOBILE" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Email</div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_EMAIL" CssClass="user" runat="server" Width="184px"></asp:TextBox>
                                </div>
                            </div>

                            <div style="float: left; width: 1050px; margin-top: 8px;">
                                <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Ngày gửi từ </div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_TUNGAY" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txt_TUNGAY" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txt_TUNGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_TUNGAY" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </div>
                                <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txt_DENNGAY" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txt_DENNGAY" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_DENNGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_DENNGAY" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </div>
                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái</div>
                                <div style="float: left">
                                    <asp:DropDownList ID="dropTrangThai" runat="server" Width="180px"
                                        CssClass="dropbox">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;">
                            <div style="float: left; width: 400px; margin-left: 50px; min-height: 10px;">
                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <div style="float: left; width: 1050px">
                                <div style="margin-left: 454px;">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="110px">
                                            <HeaderTemplate>
                                                Tên người gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("Tennguoigui") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Ngày gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAYGUI") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="230px">
                                            <HeaderTemplate>
                                                Nội dung
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("noidung") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Email
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("email") %>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="left" Width="50px"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Điện thoại
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("mobile") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Tình trạng GQ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("trangthai") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="ten" HeaderText="Đơn vị xử lý"
                                            HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THONGTIN_DON" HeaderText="Thông tin"
                                            HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Xóa</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID")%>'
                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa đơn này? ');" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="ngaytao" HeaderText="Ngày tạo"
                                            HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
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
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
