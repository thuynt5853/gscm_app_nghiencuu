<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DanhSachDonAnTH.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.DanhSachDonAnTH" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .link_view {
            color: #0e7eee;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
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
                                    <div style="width: 100%">
                                        <div style="float: left; width: 900px; margin-top: 7px;">
                                            <div style="float: left; width: 120px;">Loại đơn</div>
                                            <div style="float: left;">
                                                <asp:DropDownList runat="server" ID="ddlLoaidon"
                                                    Width="210px" CssClass="chosen-select">
                                                    <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Xin ân giảm"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Xin ân giảm + kêu oan"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; width: 120px; margin-left: 10px;">Người nhận đơn</div>
                                            <div style="float: left;">
                                                <asp:DropDownList ID="ddlThamtravien_search" CssClass="chosen-select"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div style="float: left; width: 900px; margin-top: 7px;">
                                            <div style="float: left; width: 120px;">Loại ngày</div>
                                            <div style="float: left;">
                                                <asp:DropDownList runat="server" ID="dropLoaiNgay"
                                                    Width="210px" CssClass="chosen-select">
                                                    <asp:ListItem Value="0" Text="Ngày nhận đơn"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Ngày trên đơn"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; width: 120px; margin-left: 10px;">Từ ngày</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtGQD_TuNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtGQD_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtGQD_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                            <div style="float: left; width: 60px; margin-left: 10px;">Đến ngày</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtGQD_DenNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtGQD_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtGQD_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                        </div>
                                        <div style="float: left; width: 900px; margin-top: 7px;">
                                            <div style="float: left; width: 120px;">Người gửi đơn</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="200px" MaxLength="250"></asp:TextBox>
                                            </div>
                                            <div style="float: left; width: 120px; margin-left: 10px;">Địa chỉ người gửi</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txt_DiachiNguoigui" runat="server" CssClass="user" Width="385px" MaxLength="250"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div style="float: left; width: 900px; margin-top: 7px;">
                                            
                                           <div style="float: left; width: 120px;">Tòa ra BA</div>
                                            <div style="float: left;">
                                                <asp:DropDownList runat="server" ID="ddlToaXetXu"
                                                    Width="210px" CssClass="chosen-select"> 
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; width: 120px; margin-left: 10px;">Số BA</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>  
                                            </div>
                                            <div style="float: left; width: 60px; margin-left: 10px;">Ngày BA</div>
                                            <div style="float: left;">
                                                 <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                        </div>


                                        <div>
                                            <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            </asp:Panel>
                                        </div>
                                    </div>
                                    <div style="clear: both;"></div>
                                </div>
                                <div style="margin-top:0px; margin-left: 130px;">
                                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                </div>
                                <div style="margin-top: 30px; margin-left: 130px;">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                    <asp:Button ID="btnThemmoi" runat="server" CssClass="buttoninput"
                                        Text="Thêm mới" OnClick="btnThemmoi_Click" />
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
                            <div style="">
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="STT" HeaderText="TT" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOIGUI" HeaderText="Người gửi đơn" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Người nhận" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENBIAN" HeaderText="Bị án" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="140px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAI" HeaderText="Loại đơn" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYSUA" HeaderText="Người sửa" HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <i><%#Eval("NGAYTAO") %></i>
                                                <br />
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" Font-Bold="true" CausesValidation="false"
                                                Text="Xóa" CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa đơn này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
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
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
