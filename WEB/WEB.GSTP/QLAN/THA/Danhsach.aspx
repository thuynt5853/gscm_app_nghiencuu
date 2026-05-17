<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.Danhsach" %>

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
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 75px;">Lựa chọn</td>
                                            <td style="width: 200px;">
                                                <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select"
                                                    Width="180px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="dropLoaiLuaChon_SelectedIndexChanged">
                                                </asp:DropDownList></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Mã vụ án</td>
                                            <td>
                                                <asp:TextBox ID="txtMaVuAn" CssClass="user"
                                                    runat="server" Width="170px" MaxLength="50"></asp:TextBox></td>
                                            <td style="width: 80px;">Tên vụ án</td>
                                            <td>
                                                <asp:TextBox ID="txtTenVuAn" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Mã bị án</td>
                                            <td>
                                                <asp:TextBox ID="txtMaBiAn" CssClass="user"
                                                    runat="server" Width="170px" MaxLength="50"></asp:TextBox></td>
                                            <td>Tên bị án</td>
                                            <td>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTenBiAn" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; margin-left: 10px;">
                                                    <span style="float: left; line-height: 25px; margin-right: 5px;">Số CMND</span>
                                                    <asp:TextBox ID="txtCMND" CssClass="user"
                                                        runat="server" Width="170px" MaxLength="50"></asp:TextBox>
                                                </div>
                                                <div style="float: left; margin-left: 10px;">
                                                    <asp:CheckBox ID="bian_QDTHA" runat="server" AutoPostBack="true"  style="margin-left: 10px; margin-top: 3px" Width="30px"/>
                                                    <span style="float: right; line-height: 25px;">Bị án đã có QĐ thi hành án</span>
                                                </div>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Số bản án</td>
                                            <td>
                                                <asp:TextBox ID="txtSoBanAn" CssClass="user" runat="server"
                                                    Width="170px" MaxLength="50"></asp:TextBox></td>
                                            <td>Ngày bản án</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user" Width="170px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                                    TargetControlID="txtNgayBanAn" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                                    TargetControlID="txtNgayBanAn" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" />
                                                <%-- <div style="float: left; margin-left: 10px;">
                                                    <span style="float: left; line-height: 25px; margin-right: 5px;">Trạng thái thụ lý</span>
                                                   <asp:DropDownList ID="dropTrangThaiThuLyTHA" CssClass="chosen-select"
                                                    Width="180px" runat="server" >
                                                       <asp:ListItem Text="Tất cả" Value="2"></asp:ListItem>
                                                       <asp:ListItem Text="Chưa thụ lý" Value="0"></asp:ListItem>
                                                       <asp:ListItem Text="Đã thụ lý" Value="1"></asp:ListItem>
                                                </asp:DropDownList>
                                                </div>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tình trạng GQ</td>
                                            <td>
                                                <asp:DropDownList ID="dropTinhTrangGQ" CssClass="chosen-select"
                                                    Width="180px" runat="server" AutoPostBack="true">
                                                </asp:DropDownList>
                                            </td>
                                            <td>Từ ngày</td>
                                            <td>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" MaxLength="10" Width="170px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                        TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                        TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="float: left; margin-left: 10px;">
                                                    <span style="float: left; line-height: 25px; margin-right: 10px;">Đến ngày </span>
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" MaxLength="10" Width="170px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                        TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                        TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                </div>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px;" align="left"></td>
                        <td align="left">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" Visible="false" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            <asp:Button ID="cmdInDanhSach" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="cmdInDanhsach_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
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
                            <!--------------------------------------->
                            <asp:HiddenField ID="hddBiAnID" runat="server" />
                       <%--     <table class="table2" style="width: 100%;" border="1">
                                <tr class="header">
                                    <td style="width: 15px; text-align: center">STT</td>
                                    <td style="width: 85px; text-align: center">Chọn bị án</td>
                                    <td style="width: 70px; text-align: center">Mã bị án</td>
                                    <td style="text-align: center">Bị án</td>
                                    <td style="width: 70px; text-align: center">Mã vụ án</td>
                                    <td style="text-align: center">Tên vụ án</td>
                                    <td style="width: 85px; text-align: center">Số bản án</td>
                                    <td style="width: 85px; text-align: center">Ngày bản án</td>
                                    <td style="text-align: center">Tình trạng giải quyết</td>
                                </tr>
                                <asp:Repeater ID="rpt" runat="server"
                                    OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("STT") %></td>
                                            <td>
                                                <asp:Button ID="cmdChitiet" runat="server" Text="Chọn bị án"
                                                    CssClass="buttonchitiet" CausesValidation="false"
                                                    CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'
                                                    CommandName="ThuLyAn" />
                                            </td>
                                            <td><%# Eval("MaBiAn") %></td>
                                            <td><%# Eval("TenBiAn") %></td>
                                            <td><%# Eval("MaVuAn") %></td>
                                            <td><%# Eval("TenVuAn") %></td>
                                            <td><%# Eval("SoBanAn") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYBANAN")) %></td>
                                            <td>
                                                <div class="">
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false"
                                                        CommandName="sua" ForeColor="#0e7eee" ToolTip="Sửa"
                                                        CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                                    <asp:LinkButton ID="lbtXoa" runat="server" ToolTip="Xóa"
                                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("BiAnID") %>'
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                </div>

                                                <asp:LinkButton ID="lblXoaAnTich" runat="server" Text="Xóa Án Tích" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="XoaAnTich" ToolTip='<%#Eval("VuAnID") %>'
                                                    CommandArgument='<%#Eval("VuAnID") %>'></asp:LinkButton>
                                                <asp:LinkButton ID="lblDacXa" runat="server" Text="Đặc Xá" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="DacXa" ToolTip='<%#Eval("VuAnID") %>'
                                                    CommandArgument='<%#Eval("VuAnID") %>'></asp:LinkButton>

                                                <asp:Label ID="txtTinhTrangGQ" runat="server" Text=""></asp:Label>
                                                <b><%# Eval("TINHTRANGGQ") %></b>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>--%>

                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" 
                                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" 
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound"
                                ItemStyle-CssClass="chan" Width="100%" >
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px" >
                                        <HeaderTemplate>Chọn bị án</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Button ID="cmdChitiet" runat="server" Text="Chọn bị án"
                                                CssClass="buttonchitiet" CausesValidation="false"
                                                CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'
                                                CommandName="ThuLyAn" />
                                        </ItemTemplate>
                                         <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Mã bị án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("MaBiAn") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Bị án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenBian") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Mã vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("MaVuAn") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
<%--                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Tên vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenVuAn") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>--%>
                                    <asp:TemplateColumn HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Số bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("SoBanAn") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Ngày bản án</HeaderTemplate>
                                        <ItemTemplate>
                                           <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYBANAN")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tên bị án - Tội danh</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("HOTENBIAN_TOIDANH") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" >
                                        <HeaderTemplate>Tên vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenVuAn") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số bản án/QĐ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("SOBANAN_QD") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày bản án/QĐ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYBANAN_QD")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Hình phạt tổng hợp</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("HINHPHAT_TONGHOP") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số thụ lý - Ngày thụ lý THA</HeaderTemplate>
                                        <ItemTemplate>
                                           <%# Eval("THA_SOTHULY_NGAYTHULY") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số QĐ Thi hành án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("THA_QD_SO") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tình trạng GQ</HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="" style="display:none">
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false"
                                                        CommandName="sua" ForeColor="#0e7eee" ToolTip="Sửa"
                                                        CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                                    <asp:LinkButton ID="lbtXoa" runat="server" ToolTip="Xóa"
                                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("BiAnID") %>'
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                <asp:LinkButton ID="lblXoaAnTich" runat="server" Text="Xóa Án Tích" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="XoaAnTich" ToolTip='<%#Eval("VuAnID") %>'
                                                    CommandArgument='<%#Eval("VuAnID") %>'></asp:LinkButton>
                                                <asp:LinkButton ID="lblDacXa" runat="server" Text="Đặc Xá" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="DacXa" ToolTip='<%#Eval("VuAnID") %>'
                                                    CommandArgument='<%#Eval("VuAnID") %>'></asp:LinkButton>
                                                </div>

                                                
                                           <%# Eval("TINHTRANGGQ") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>

                            <!--------------------------------------->
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
    <script>
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


</asp:Content>
