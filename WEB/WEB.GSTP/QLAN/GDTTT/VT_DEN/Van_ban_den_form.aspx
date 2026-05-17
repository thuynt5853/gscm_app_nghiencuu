<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP_VBD.Master" AutoEventWireup="true" CodeBehind="Van_ban_den_form.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VT_DEN.Van_ban_den_form" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />
    <div style="position: absolute; height: 60px; width: 100px; right: 100px; top: 200px; color: #139913; font-weight: bold;">
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" DisplayAfter="10" AssociatedUpdatePanelID="Ajax_Manager_Updata">
            <ProgressTemplate>
                <i class="fa fa-spinner fa-spin fa-5x fa-fw"></i><span class="sr-only">Loading...</span>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
    <asp:UpdatePanel runat="server" ID="Ajax_Manager_Updata">
        <ContentTemplate>
            <div class="box">
                <div class="box_nd">
                    <div class="truong">
                        <table class="table1">
                            <tr>
                                <td colspan="2">
                                    <div class="boxchung">
                                        <h4 class="tleboxchung">Tìm kiếm</h4>
                                        <div class="boder" style="padding: 10px;">
                                            <table class="table1">
                                                <tr>
                                                    <td>
                                                        <div style="float: left; width: 900px;">
                                                            <div style="float: left; width: 100px; text-align: right">Nguồn đến</div>
                                                            <div style="float: left; width: 170px; margin-left: 6px;">
                                                                <asp:DropDownList ID="Drop_NGUONDEN_SEARCH" CssClass="chosen-select" runat="server" Width="200px">
                                                                    <asp:ListItem Value="" Text="---Chọn---" Selected="True"></asp:ListItem>
                                                                    <asp:ListItem Value="1" Text="Bưu điện"></asp:ListItem>
                                                                    <asp:ListItem Value="2" Text="Tiếp công dân"></asp:ListItem>
                                                                    <asp:ListItem Value="3" Text="Trực tiếp"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Người đứng đơn</div>
                                                            <div style="float: left; width: 170px; margin-left: 6px;">
                                                                <asp:TextBox ID="txt_NGUOIDUNGDON_SEARCH" runat="server"
                                                                    CssClass="user" Width="170px" Text=""></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right">Loại văn bản</div>
                                                            <div style="float: left; width: 170px; margin-left: 6px;">
                                                                <asp:DropDownList ID="DROP_LOAI_VB_SEARCH" CssClass="chosen-select" runat="server" Width="170px">
                                                                    <asp:ListItem Value="" Selected="True" Text="---Tất cả---"></asp:ListItem>
                                                                    <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                                                    <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                                    <%--  <asp:ListItem Value="2" Text="Công văn"></asp:ListItem>--%>
                                                                    <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                                                    <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                                                    <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                                                    <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm theo Hồ sơ"></asp:ListItem>
                                                                    <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                                                    <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Loại án</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:DropDownList ID="Drop_LOAI_AN_DON_SEARCH" CssClass="chosen-select"
                                                                    runat="server" Width="170px">
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right;">Đơn vị nhận</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:DropDownList ID="Drop_NOI_NHAN_SEARCH" CssClass="chosen-select" runat="server" Width="170px">
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; display: none;">Người nhận</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px; display: none;">
                                                                <asp:DropDownList ID="Drop_NGUOI_NHAN_SEARCH" CssClass="chosen-select" runat="server" Width="170px">
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Tòa án ra BA/QĐ</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:DropDownList ID="Drop_TOAAN_BAQD_DON_SEARCH" CssClass="chosen-select" runat="server" Width="200px">
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Số BA/QĐ</div>
                                                            <div style="float: left; width: 170px; margin-left: 6px;">
                                                                <asp:TextBox ID="txt_SO_BAQD_DON_SEARCH" runat="server"
                                                                    CssClass="user" Width="170px" Text=""></asp:TextBox>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right;">Ngày BA/QĐ</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_NGAY_BAQD_DON_SEARCH" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txt_NGAY_BAQD_DON_SEARCH" Format="dd/MM/yyyy" Enabled="true" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txt_NGAY_BAQD_DON_SEARCH" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            </div>

                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Số đến từ</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_SODEN_SEARCH" runat="server"
                                                                    CssClass="user" Width="170px" MaxLength="250" Text=""></asp:TextBox>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Đến</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_SODEN_SEARCH_DEN" runat="server"
                                                                    CssClass="user" Width="170px" MaxLength="250" Text=""></asp:TextBox>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; display: none;">Mã</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px; display: none;">
                                                                <asp:TextBox ID="txt_ID_SEARCH" runat="server"
                                                                    CssClass="user" Width="170px" MaxLength="250" Text=""></asp:TextBox>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right;">Người tạo</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_NGUOITAO_SEARCH" runat="server" ToolTip="User đăng nhập"
                                                                    CssClass="user" Width="170px" MaxLength="250" Text=""></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right">Loại ngày</div>
                                                            <div style="float: left; width: 170px; margin-left: 6px;">
                                                                <asp:DropDownList ID="drop_LOAI_NGAY_SEARCH" CssClass="chosen-select" runat="server" Width="170px">
                                                                    <asp:ListItem Value="0" Selected="True" Text="Ngày nhập"></asp:ListItem>
                                                                    <asp:ListItem Value="1" Text="Ngày đến"></asp:ListItem>
                                                                    <asp:ListItem Value="2" Text="Ngày trên bì thư"></asp:ListItem>
                                                                    <asp:ListItem Value="3" Text="Ngày chuyển"></asp:ListItem>
                                                                    <asp:ListItem Value="4" Text="Ngày nhận"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Từ ngày</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_NGAY_FROM" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txt_NGAY_FROM" Format="dd/MM/yyyy" Enabled="true" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txt_NGAY_FROM" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            </div>
                                                            <div style="float: left; width: 100px; text-align: right;">Đến ngày</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_NGAY_TO" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txt_NGAY_TO" Format="dd/MM/yyyy" Enabled="true" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txt_NGAY_TO" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Người gửi/Đơn vị gửi</span></div>
                                                            <div style="float: left; width: 730px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_NGUOI_GUI_BT_SEARCH" runat="server"
                                                                    CssClass="user" Width="730px" Text=""></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Địa chỉ gửi</div>
                                                            <div style="float: left; width: 730px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_DIACHI_GUI_BT_SEARCH" runat="server"
                                                                    CssClass="user" Width="730px" Text=""></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Ghi chú</div>
                                                            <div style="float: left; width: 730px; margin-left: 7px;">
                                                                <asp:TextBox ID="txt_GHICHU_SEARCH" runat="server"
                                                                    CssClass="user" Width="730px" Text=""></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div style="float: left; width: 900px; margin-top: 5px;">
                                                            <div style="float: left; width: 100px; text-align: right;">Trạng thái chuyển</div>
                                                            <div style="float: left; width: 170px; margin-left: 7px;">
                                                                <asp:DropDownList ID="Drop_TRANGTHAICHUYEN" AutoPostBack="true" OnSelectedIndexChanged="Drop_TRANGTHAICHUYEN_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="170px">
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" colspan="6">
                                                        <div style="float: left; margin-top: 17px; margin-left: 490px;">
                                                            <asp:HiddenField ID="Hi_update" runat="server" />
                                                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                            <asp:Button ID="cmdLammoi_search" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_search_Click" />
                                                            <asp:Button ID="btnThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                                                            <%-------------------------%>
                                                            <asp:Button ID="cmdChuyen" runat="server" CssClass="buttoninput" Text="Chuyển" OnClick="cmdChuyen_Click" />
                                                            <asp:Button ID="cmdHuychuyen" runat="server" CssClass="buttoninput" Text="Thu Hồi" OnClientClick="return confirm('Bạn thực sự muốn Thu hồi ? ');" OnClick="cmdHuychuyen_Click" />
                                                            <asp:Button ID="cmdNhanan" runat="server" CssClass="buttoninput" Text="Nhận" OnClick="cmdNhanan_Click" />
                                                            <asp:Button ID="cmdHuyNhan" runat="server" CssClass="buttoninput" Text="Hủy nhận " OnClientClick="return confirm('Bạn thực sự muốn hủy nhận ? ');" OnClick="cmdHuyNhan_Click" />

                                                        </div>
                                                    </td>
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
                                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
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
                                    <%-----------------------------------------------%>
                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%"
                                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                        <Columns>
                                            <asp:BoundColumn DataField="STT" HeaderText="TT"
                                                HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    <div style="padding-top: 3px;">
                                                        <asp:CheckBox ID="chkFullAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkFullAll_CheckChange" />
                                                    </div>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Số đến/Ngày đến</HeaderTemplate>
                                                <ItemTemplate>
                                                    <b> <%# Eval("SODEN") %></b><br />
                                                     <%# Eval("NGAY_DEN") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Ngày ghi trên đơn<br />
                                                    /dấu bưu điện
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("NGAY_BT") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Người gửi/Địa chỉ gửi</HeaderTemplate>
                                                <ItemTemplate>
                                                    <b><%# Eval("NGUOI_GUI_BT") %></b>
                                                    <br />
                                                    <%# Eval("DIACHI_GUI_BT") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Người đứng đơn</HeaderTemplate>
                                                <ItemTemplate>
                                                    <b><%# Eval("NGUOIDUNGDON") %></b>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Đơn vị nhận/người nhận</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("DV_NHAN_NGUOI_NHAN") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Loại văn bản</HeaderTemplate>
                                                <ItemTemplate>
                                                    <b><%# Eval("LOAI_VB_TEN") %></b>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Số BA,Ngày BA,Tòa XX</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("SOBA_NGAYBA_TOA_XX") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Nguồn đến</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("NGUON_DEN") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Ghi chú</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("GHICHU") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("TRANGTHAICHUYEN_TEN") %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="left"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Người tạo/ Ngày tạo</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("NGUOI_TAO") %><br />
                                                    <i><%#Eval("NGAY_TAO") %></i><br />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("ID") %>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" Font-Bold="true" CausesValidation="false"
                                                Text="Xóa" CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                    <br />
                                                    <div style="margin-top: 7px;">
                                                        <asp:LinkButton ID="lblChitiet" runat="server" Text="Chi tiết" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                            CommandName="Chitiet" CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("ID") %>'></asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                    <%-----------------------------------------------%>
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
        </ContentTemplate>
    </asp:UpdatePanel>
    <div runat="server" id="id_Judge_add" style="display: none; visibility: hidden;"></div>
    <cc1:ModalPopupExtender ID="MP_Add" BehaviorID="mpe_vbd" runat="server" Y="30" X="250"
        PopupControlID="P_VBD" TargetControlID="id_Judge_add" PopupDragHandleControlID="id_header" BackgroundCssClass="modalBackground"
        CancelControlID="cmd_close_window">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="P_VBD" runat="server" CssClass="modalPopup" Style="display: none;">
        <div id="id_header" class="Form_Mover"></div>
        <asp:UpdatePanel runat="server" ID="id_upload_manager">
            <ContentTemplate>
                <div class="header" style="">
                    <div class="head_windowList">
                        <div class="HeadResend">
                            <asp:Label ID="txt_head_judge" runat="server" Text="Nhập thông tin văn bản đến"></asp:Label>
                        </div>
                        <img id="cmd_close_window" alt="Thoát" src="../../../UI/img/close.png" onclick="javascript:HideModalPopup();" />
                    </div>
                </div>
                <div class="body" style="overflow-y: scroll;">
                    <div style="float: left; position: absolute; right: 30px; bottom: 10px;">
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="id_upload_manager"
                            DisplayAfter="10">
                            <ProgressTemplate>
                                <i class="fa fa-spinner fa-spin fa-5x fa-fw"></i><span class="sr-only">Loading...</span>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                    <div style="float: left; width: 860px; margin-top: 10px; margin-left: 7px;">
                        <%--------------Bì thư---------------------%>
                        <div style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                            <h4 class="tleboxchung"><b>Nhập thông tin Bì thư</b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="width: 810px; float: left;">
                                    <div style="float: left; width: 120px; text-align: right;">Nguồn đến</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="Drop_NGUONDEN" CssClass="chosen-select" runat="server" Width="200px"
                                            AutoPostBack="true" OnSelectedIndexChanged="Drop_NGUONDEN_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="---Chọn---" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Bưu điện"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Tiếp công dân"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Trực tiếp"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left; width: 190px; text-align: right;">Đơn vị nhận</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="Drop_NOI_NHAN" CssClass="chosen-select" runat="server" Width="200px"
                                            AutoPostBack="true" OnSelectedIndexChanged="Drop_NOI_NHAN_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 8px;">
                                    <div style="float: left; width: 120px; text-align: right;">Loại văn bản<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="Drop_LOAI_VB" CssClass="chosen-select" runat="server" Width="200px"
                                            AutoPostBack="true" OnSelectedIndexChanged="Drop_LOAI_VB_SelectedIndexChanged">
                                            <asp:ListItem Value ="" Text="---Chọn---" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                            <%--  <asp:ListItem Value="2" Text="Công văn"></asp:ListItem>--%>
                                            <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm theo Hồ sơ"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left; width: 190px; text-align: right;">Đơn vị giải quyết</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="Drop_DVXULY_ID_DON"
                                            CssClass="chosen-select" runat="server" Width="200px">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <div style="width: 810px; float: left; margin-top: 5px;">
                                    <div style="float: left; width: 120px; text-align: right;">Số đến<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_SODEN" runat="server"
                                            CssClass="user" Width="200px" MaxLength="250" onkeypress="return isNumber(event)" Text=""></asp:TextBox>
                                    </div>
                                    <div runat="server" id="div_NGUOI_NHAN">
                                        <div style="float: left; width: 190px; text-align: right;">Người nhận</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:DropDownList ID="Drop_NGUOI_NHAN" CssClass="chosen-select" runat="server" Width="200px">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 5px;">
                                    <div style="float: left; width: 120px; text-align: right;">Ngày đến/Ngày nhận trực tiếp<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_NGAY_DEN" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txt_NGAY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txt_NGAY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                    <div style="float: left; width: 190px; text-align: right;">Ngày giao</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txtNgaygiao" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgaygiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgaygiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                </div>
                                <div style="width: 810px; margin-top: 10px; float: left; display: none;">
                                    <div style="float: left; width: 120px; text-align: right;">Người nhận</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="Drop_CANBONHAN_ID" CssClass="chosen-select" runat="server" Width="200px">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div runat="server" id="div_MABUUDIEN" style="width: 810px; float: left; margin-top: 8px;">
                                    <div style="float: left; width: 120px; text-align: right;">Mã bưu điện</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_MABUUDIEN" runat="server"
                                            CssClass="user" Width="200px" Text=""></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 190px; text-align: right;">
                                        <asp:Label runat="server" ID="lbl_NGAY_BT_NAME"></asp:Label>
                                    </div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_NGAY_BT" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAY_BT" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_NGAY_BT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                </div>
                                <div runat="server" id="div_SOLUONG_GAM" style="width: 810px; float: left; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right;">Cân nặng của Hồ sơ (gam)</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_SOLUONG_GAM" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbe" runat="server" TargetControlID="txt_SOLUONG_GAM" FilterType="Custom, Numbers" ValidChars="+-=/*()." />
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 5px;">
                                    <div style="float: left; width: 120px; text-align: right;">Người gửi/Đơn vị gửi</div>
                                    <div style="float: left; width: 597px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_NGUOI_GUI_BT" runat="server"
                                            CssClass="user" Width="597px" Text=""></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 5px;">
                                    <div style="float: left; width: 120px; text-align: right;">Địa chỉ gửi</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="ddl_DIACHI_GUI_BT_ID" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                    </div>
                                    <div style="float: left; width: 70px; text-align: right;">Chi tiết</div>
                                    <div style="float: left; width: 320px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_DIACHI_GUI_BT" runat="server"
                                            CssClass="user" Width="320px" Text=""></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 9px;">
                                    <div style="float: left; width: 120px; text-align: right;">
                                        <asp:Label runat="server" ID="lblGhiChu" Text="Ghi chú"></asp:Label>
                                    </div>
                                    <div style="float: left; width: 597px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_GHICHU" runat="server"
                                            CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--------------văn bản hành chính---------------------%>
                        <div id="div_vbhc" runat="server" style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                            <h4 class="tleboxchung"><b>Nhập thông tin văn bản hành chính</b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="float: left; width: 810px; margin-top: 10px; margin-left: 5px;">
                                    <div style="width: 810px; float: left;">
                                        <div style="float: left; width: 120px; text-align: right;">Độ mật</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:DropDownList ID="drop_DOMAT" CssClass="chosen-select" runat="server" Width="200px">
                                                <asp:ListItem Value="" Text="---Chọn---" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Mật"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tối mật"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tuyệt mật"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; width: 190px; text-align: right;">Độ khẩn</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:DropDownList ID="drop_DOKHAN" CssClass="chosen-select" runat="server" Width="200px">
                                                <asp:ListItem Value="" Text="---Chọn---" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Khẩn"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Hỏa tốc"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Thượng khẩn"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 9px;">
                                        <div style="float: left; width: 120px; text-align: right;">Số văn bản</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_SO_VB" runat="server"
                                                CssClass="user" Width="200px" Text=""></asp:TextBox>
                                        </div>
                                        <div style="float: left; width: 190px; text-align: right;">Ngày văn bản</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NGAY_VB" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAY_VB" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAY_VB" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 9px;">
                                        <div style="float: left; width: 120px; text-align: right;">Nội dung trích yếu</div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NOIDUNG_VB" runat="server"
                                                CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 120px; text-align: right;">Lãnh đạo trả ra</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:RadioButtonList ID="rdb_LDTRA_RA" runat="server" Width="200px"
                                                RepeatDirection="Horizontal" AutoPostBack="True"
                                                OnSelectedIndexChanged="rdb_LDTRA_RA_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Không" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                    </div>
                                    <%-------SUB lãnh đạo trả ra-----------%>
                                    <div runat="server" id="div_LANHDAOTRA_RA">
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Ngày trả ra</div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:TextBox ID="txt_NGAYTRA_RA_VB" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txt_NGAYTRA_RA_VB" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txt_NGAYTRA_RA_VB" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                        </div>
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Bút phê của lãnh đạo</div>
                                            <div style="float: left; width: 597px; margin-left: 7px;">
                                                <asp:TextBox ID="txt_BUTPHE_LANHDAO_VB" runat="server"
                                                    CssClass="user" Width="597px" Text=""></asp:TextBox>
                                            </div>
                                        </div>
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Người GQ/Đơn vị GQ</div>
                                            <div style="float: left; width: 597px; margin-left: 7px;">
                                                <asp:TextBox ID="txt_DONVI_GQ_VB" runat="server"
                                                    CssClass="user" Width="597px" Text=""></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <%-------SUB lãnh đạo trả ra end-----------%>
                                </div>
                            </div>
                        </div>
                        <%--------------Thông tin đơn---------------------%>
                        <div id="div_don" runat="server" style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                            <h4 class="tleboxchung"><b>Nhập thông tin đơn</b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="width: 810px; float: left; margin-top: 5px;">
                                    <div style="float: left; width: 120px; text-align: right;">Người đứng đơn</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_NGUOIDUNG_DON" runat="server"
                                            CssClass="user" Width="200px" Text=""></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 810px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 120px; text-align: right;">Địa chỉ người đứng đơn</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:DropDownList ID="ddl_DIACHI_NDD_ID" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                    </div>
                                    <div style="float: left; width: 70px; text-align: right;">Chi tiết</div>
                                    <div style="float: left; width: 320px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_DIACHI_NG_DUNGDON" runat="server"
                                            CssClass="user" Width="320px" Text=""></asp:TextBox>
                                    </div>
                                </div>
                                <div style="float: left; width: 810px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right;">Số lượng đơn</div>
                                    <div style="float: left; width: 200px; margin-left: 7px;">
                                        <asp:TextBox ID="txt_SOLUONG_DON" runat="server"
                                            CssClass="user" Width="200px" Text="" onkeypress="return isNumber(event)"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%-------Công văn chuyển đơn (đơn + CV) hoặc Công văn -----------%>
                        <div id="div_Don_CV" runat="server" style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                            <h4 class="tleboxchung"><b>
                                <asp:Label runat="server" ID="lbl_loaiCV" Text="Công văn chuyển đơn"></asp:Label>
                            </b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="float: left; width: 810px; margin-top: 10px; margin-left: 5px;">
                                    <div style="width: 810px; float: left;">
                                        <div style="float: left; width: 120px; text-align: right;">Số công văn</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_SO_CV" runat="server"
                                                CssClass="user" Width="200px" Text=""></asp:TextBox>
                                        </div>
                                        <div style="float: left; width: 190px; text-align: right;">Ngày công văn</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NGAY_CV" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txt_NGAY_CV" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NGAY_CV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 5px;">
                                        <div style="float: left; width: 120px; text-align: right;">Cơ quan/Đơn vị chuyển</div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_DONVICHUYEN_CV" runat="server"
                                                CssClass="user" Width="597px" Text=""></asp:TextBox>
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 5px;">
                                        <div style="float: left; width: 120px; text-align: right;">Nội dung</div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NOIDUNG_CV" runat="server"
                                                CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <%--Thong tin khang nghi cua VKS--%>
                        <div id="div_VKS" runat="server" style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                            <h4 class="tleboxchung"><b>Thông tin Quyết định Kháng nghị</b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="float: left; width: 810px; margin-top: 10px; margin-left: 5px;">

                                    <div style="width: 810px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 120px; text-align: right;">Số QĐKN<span runat="server" id="id_span_txtSOKN" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txtSOKN" runat="server"
                                                CssClass="user" Width="200px" Text=""></asp:TextBox>
                                        </div>
                                        <div style="float: left; width: 190px; text-align: right;">Ngày QĐKN<span runat="server" id="id_span_txt_NGAYQDKN" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NGAYQDKN" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txt_NGAYQDKN" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txt_NGAYQDKN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 120px; text-align: right;">Người Kháng nghị<span runat="server" id="id_span_dropVKS_NguoiKy" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:DropDownList ID="dropVKS_NguoiKy" CssClass="chosen-select"
                                                runat="server" Width="200px">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 5px;">
                                        <div style="float: left; width: 120px; text-align: right;">Ghi chú</div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_GHICHU_HS" runat="server"
                                                CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <%--End VKS--%>

                        <%------Bản án Quyết định-----------%>
                        <div id="div_BAQD" runat="server" style="float: left; width: 100%; position: relative; margin-bottom: 10px;">

                            <h4 class="tleboxchung"><b>
                                <asp:Label ID="lblInforBA" runat="server" Text="Thông tin Bản án/Quyết định"></asp:Label></b></h4>
                            <div class="boder" style="float: left; padding: 2%; width: 100%;">
                                <div style="float: left; width: 810px; margin-top: 10px; margin-left: 5px;">
                                    <div style="width: 810px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 120px; text-align: right;">
                                            <asp:Label ID="lblLoaiDeNghi" runat="server" Text="Đề nghị theo thủ tục"></asp:Label><span runat="server" id="id_span_drop_LoaiGDT" style="color: #ff0000; padding-left: 5px;">(*)</span>
                                        </div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:DropDownList ID="drop_LoaiGDT" AutoPostBack="true" CssClass="chosen-select"
                                                runat="server" Width="200px">
                                                <asp:ListItem Value="0" Text="Chọn" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Giám đốc thẩm"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tái thẩm"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="width: 810px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 120px; text-align: right;">BA/QĐ</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:RadioButtonList ID="rdb_BAQD_CHECK" runat="server" Width="200px"
                                                RepeatDirection="Horizontal" AutoPostBack="True"
                                                OnSelectedIndexChanged="rdb_BAQD_CHECK_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Có" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                    </div>
                                    <%-------SUB Thông tin bản án quyết định-----------%>
                                    <div id="div_BA_QD" runat="server" style="display: none;">
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Số BA/QĐ<span runat="server" id="id_span_txt_SO_BAQD_DON" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:TextBox ID="txt_SO_BAQD_DON" runat="server"
                                                    CssClass="user" Width="200px" Text=""></asp:TextBox>
                                            </div>
                                            <div style="float: left; width: 190px; text-align: right;">Ngày BA/QĐ<span runat="server" id="id_span_txt_NGAY_BAQD_DON" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:TextBox ID="txt_NGAY_BAQD_DON" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NGAY_BAQD_DON" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAY_BAQD_DON" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                        </div>
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Tòa án ra BA/QĐ<span runat="server" id="id_span_Drop_TOAAN_BAQD_DON" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:DropDownList ID="Drop_TOAAN_BAQD_DON" CssClass="chosen-select" runat="server" Width="200px">
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; width: 190px; text-align: right;">Cấp xx<span runat="server" id="id_span_Drop_CAP_XX_DON" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:DropDownList ID="Drop_CAP_XX_DON" CssClass="chosen-select"
                                                    runat="server" Width="200px">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div style="width: 810px; float: left; margin-top: 7px;">
                                            <div style="float: left; width: 120px; text-align: right;">Loại án<span runat="server" id="id_span_Drop_LOAI_AN_DON" style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                            <div style="float: left; width: 200px; margin-left: 7px;">
                                                <asp:DropDownList ID="Drop_LOAI_AN_DON" AutoPostBack="true" OnSelectedIndexChanged="Drop_LOAI_AN_DON_SelectedIndexChanged" CssClass="chosen-select"
                                                    runat="server" Width="200px">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <div runat="server" id="div_DANSU_EXT" style="width: 810px; float: left; margin-top: 7px; display: none;">
                                        <div style="float: left; width: 120px; text-align: right;">
                                            Nguyên đơn (đại diện)
                                        </div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_NGUYENDON" runat="server"
                                                CssClass="user" Width="200px" Text=""></asp:TextBox>
                                        </div>
                                        <div style="float: left; width: 190px; text-align: right;">Bị đơn (đại diện)</div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_BIDON" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div runat="server" id="div_HINHSU" style="width: 810px; float: left; margin-top: 7px; display: none;">
                                        <div style="float: left; width: 120px; text-align: right;">
                                            Bị cáo (Đầu vụ)
                                        </div>
                                        <div style="float: left; width: 200px; margin-left: 7px;">
                                            <asp:TextBox ID="txt_BICAO_HS" runat="server"
                                                CssClass="user" Width="200px" Text=""></asp:TextBox>
                                        </div>
                                    </div>
                                    <div runat="server" id="div_QHPL_DS" style="width: 810px; float: left; margin-top: 7px; display: none;">
                                        <div style="float: left; width: 120px; text-align: right;">
                                            Quan hệ pháp luật
                                        </div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:TextBox ID="txtQHPL" runat="server"
                                                CssClass="user" Width="597px" Text=""></asp:TextBox>
                                        </div>
                                    </div>
                                    <div runat="server" id="div_QHPL" style="width: 810px; float: left; margin-top: 7px; display: none;">
                                        <div style="float: left; width: 120px; text-align: right;">
                                            Tội danh
                                        </div>
                                        <div style="float: left; width: 597px; margin-left: 7px;">
                                            <asp:DropDownList ID="Drop_QHPL" CssClass="chosen-select"
                                                runat="server" Width="597px">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <%--End BA QD--%>
                        <div style="width: 810px; float: left; margin-top: 10px; margin-bottom: 10px; text-align: left;">
                            <div style="float: left;">
                                <div style="float: left; margin-top: 5px; width: 466px; text-align: center;">
                                    <asp:Label runat="server" ID="lbtthongbao_popup" ForeColor="Red" Font-Size="16px"></asp:Label>
                                </div>
                                <div style="float: left; margin-left: 20px;">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                </div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:Button ID="cmdLammoi_popup" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_popup_Click" />
                                </div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:Button ID="cmd_thoat" runat="server" CssClass="buttoninput" Text="Thoát" OnClientClick="javascript:HideModalPopup();" />
                                </div>
                                <%-- <div style="float: left; margin-left: 7px; display: none;">
                                    <asp:Button ID="cmdLammoi_popup_temp" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_popup_temp_Click" />
                                </div>--%>
                            </div>
                            <div style="height: 100px"></div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <script type="text/javascript">
         function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function HideModalPopup() {
            $find("mpe_vbd").hide();
            return false;
        }
        function chosen_Load_Popup_clear() {
            $("#<%= cmdLammoi_popup.ClientID %>").click();
        }
       <%-- function chosen_Load_Popup_temp() {
            $("#<%= cmdLammoi_popup_temp.ClientID %>").click();
        }--%>
        function Check_chuyendon() {
            if (window.confirm('Bạn muốn chuyển bản ghi  này ?')) {
                return true;
            }
            else {
                return false;
            }
        }
        function Check_thuhoi() {
            if (window.confirm('Bạn muốn Thu hồi bản ghi này ?')) {
                return true;
            }
            else {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            $('.chosen-container-single').css('width', '100%');
        }
    </script>

</asp:Content>
