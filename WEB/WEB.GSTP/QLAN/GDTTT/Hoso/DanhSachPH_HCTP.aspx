<%@ Page Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DanhSachPH_HCTP.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.DanhSachPH_HCTP" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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

        .margin_left {
            margin-left: 5px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddCA_ID" runat="server" Value="0" />
    <asp:HiddenField ID="hddKetquaID" runat="server" Value="0" />
    <asp:HiddenField ID="hddLoaiToa" runat="server" Value="CAPHUYEN" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Tìm kiếm
                </h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 80px">Người gửi</td>
                            <td style="width: 260px">
                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                            </td>
                            <td style="width: 80px">Số BA/QĐ</td>
                            <td style="width: 260px">
                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="222px" MaxLength="50"></asp:TextBox>
                            </td>
                            <td style="width: 80px">Ngày BA/QĐ</td>
                            <td style="width: 260px">
                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Tòa ra BA/QĐ</td>
                            <td>
                                <asp:DropDownList ID="ddlToaXetXu" CssClass="user" runat="server" Width="230px"></asp:DropDownList></td>
                            <td>Loại án</td>
                            <td>
                                <asp:DropDownList ID="ddlLoaiAn" CssClass="user" runat="server" Width="230px">
                                    <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Hình sự"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Dân sự"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Hôn nhân, gia đình"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Kinh doanh, thương mại"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Lao động"></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Hành chính"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Phá sản"></asp:ListItem>
                                    <asp:ListItem Value="-1" Text="Chưa xác định"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>TT phát hành</td>
                            <td>
                                <asp:DropDownList ID="ddlTTPhatHanh" CssClass="user" runat="server" Width="230px">
                                    <asp:ListItem Value="0" Text="--- Tất cả ---"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Đã phát hành"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Chưa phát hành"></asp:ListItem>
                                    <asp:ListItem Value="3" Text=" - Đã chuyển văn thư"></asp:ListItem>
                                    <asp:ListItem Value="4" Text=" - Chưa chuyển văn thư" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td><b>Nơi chuyển</b></td>
                            <td>
                                <asp:DropDownList ID="ddlNoichuyenden" CssClass="chosen-select user" runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlNoichuyenden_SelectedIndexChanged">
                                    <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Nội bộ"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Tòa khác"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Ngoài tòa án"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Xếp đơn"></asp:ListItem>
                                    <asp:ListItem Value="-2" Text="Tòa khác + Ngoài tòa án"></asp:ListItem>
                                </asp:DropDownList></td>
                            <td><b>Chuyển đến</b></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlPhongban" Visible="false" CssClass="chosen-select user" runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:Panel ID="pnToakhac" runat="server" Visible="false">
                                    <asp:DropDownList ID="ddlToaKhac" CssClass="chosen-select user" runat="server" Width="230px"></asp:DropDownList>

                                </asp:Panel>
                                <asp:TextBox ID="txtNgoaitoaan" Visible="false" CssClass="user" runat="server" Width="222px"></asp:TextBox>
                                <asp:DropDownList ID="ddlTrangthaidon" Visible="false" CssClass="chosen-select user" runat="server" Width="192px">
                                    <asp:ListItem Value="-1" Text="--Trạng thái đơn--"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Đơn đủ điều kiện"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Đơn chưa đủ điều kiện"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="  - Chưa thụ lý"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="  - Đã thụ lý"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="  - Quá 1 tháng chưa bổ sung"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Loại văn bản</td>
                            <td>
                                <asp:DropDownList ID="ddlLoaiVanBan" CssClass="user" runat="server" Width="230px">
                                    <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Yêu cầu bổ sung"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Giấy xác nhận nhận đơn"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Thông báo phân công thẩm phán"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Thông báo gửi cơ quan chuyển đơn"></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Công văn"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Tờ trình"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>Từ số</td>
                            <td>
                                <asp:TextBox ID="txtTuSo" runat="server" CssClass="user" Width="222px" MaxLength="20"></asp:TextBox>
                            </td>
                            <td>Đến số</td>
                            <td>
                                <asp:TextBox ID="txtDenSo" runat="server" CssClass="user" Width="222px" MaxLength="20"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Thụ lý đơn</b></td>
                            <td>
                                <asp:DropDownList ID="ddlThuLy" CssClass="chosen-select user" runat="server" Width="230px">
                                    <asp:ListItem Value="-1" Text="--Tất cả--"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Thụ lý mới"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Đã thụ lý"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>Ngày VB từ</td>
                            <td>
                                <asp:TextBox ID="txtNgayVBTu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayVBTu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayVBTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Đến ngày</td>
                            <td>
                                <asp:TextBox ID="txtNgayVBDen" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayVBDen" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayVBDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr></tr>
                    </table>
                </div>
                <div style="float: left; width: 900px; margin-top: 15px;">
                    <div style="float: left; width: 400px; margin-left: 50px; min-height: 10px;">
                        <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                    </div>
                    <div style="float: left;">
                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                    </div>
                    <div style="float: left; margin-left: 5px;">
                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                    </div>
                    <div style="float: left; margin-left: 5px;">
                        <asp:Button ID="cmdChuyenPH" runat="server" CssClass="buttoninput" Text="Chuyển phát hành" OnClick="cmdChuyenPH_Click" />
                    </div>
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
                            <asp:DropDownList ID="ddlPageCount" Visible="true" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan"
                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                        <Columns>
                            <asp:TemplateColumn HeaderStyle-Width="3%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkChonAll" AutoPostBack="true" ToolTip="Chọn tất cả" runat="server" OnCheckedChanged="chkChonAll_CheckedChanged"/>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID") + "#" + Eval("DONID") +"#"+ Convert.ToInt16( Eval("LOAIVB")+"") %>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="3%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>STT</HeaderTemplate>
                                <ItemTemplate></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Văn bản</HeaderTemplate>
                                <ItemTemplate><%#Eval("TENVANBAN")%></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Nơi nhận</HeaderTemplate>
                                <ItemTemplate><%#Eval("NOINHAN")%></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="8%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày gửi</HeaderTemplate>
                                <ItemTemplate><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYGUI")) %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="8%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày phát hành</HeaderTemplate>
                                <ItemTemplate><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="8%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày nhận</HeaderTemplate>
                                <ItemTemplate><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYNHAN")) %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="6%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Trạng thái</HeaderTemplate>
                                <ItemTemplate><%#Eval("TRANGTHAI")%></ItemTemplate>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Panel ID="pn_TTD" runat="server" Visible="false">
                                        <i>Người gửi:</i><b> <%#Eval("NGUOIGUI") %></b> 
                                        <br />
                                        <i>Địa chỉ</i>:<b> <%#Eval("DIACHIGUI") %></b><br />
                                        <i>Ngày trên đơn</i>: <b><%# GetDate(Eval("NGAYGHITRENDON")) %></b>
                                        &nbsp;
                                        <i>Ngày nhận</i>: <b><%# GetDate(Eval("NGAYNHANDON")) %></b>
                                        <br />
                                        <i>Số </i><b><%#Eval("BAQD") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                                        &nbsp;<b><%#Eval("TOAXX") %></b><br />
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lblPhatHanh" Visible="false" runat="server" Text="Phát hành" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                        CommandName="PhatHanh" CommandArgument='<%#Eval("DONID") +"#"+ Convert.ToInt16( Eval("LOAIVB")+"") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="lblSua" Visible="false" runat="server" Text="Sửa" Font-Bold="true" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") + "#" + Eval("DONID") +"#"+ Convert.ToInt16( Eval("LOAIVB")+"") %>'></asp:LinkButton>                                    
                                    <asp:LinkButton ID="lbtXoa" Visible="false" runat="server" Font-Bold="true" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CssClass="margin_left"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
                            <asp:DropDownList ID="ddlPageCount2" Visible="true" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function Loads_KQ() {
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
