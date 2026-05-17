<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopDKNhanVB.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.TopDKNhanVB" %>
<div class="right_full_width distance_bottom">
    <div class="guidonkien_head_nobg">
        <a href="/Personnal/DsDangKyNhanVBTongDat.aspx" class="color_black">Đăng ký nhận Văn bản, thông báo của Tòa án</a>
        <a href="/Personnal/DsDangKyNhanVBTongDat.aspx" class="viewmore">Xem thêm</a>
    </div>
    <asp:HiddenField ID="hddSoLuong" runat="server" Value="5" />
    <div class="msg_thongbao">
        <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
    </div>

    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
        <HeaderTemplate>
            <div class="CSSTableGenerator">
                <table>
                    <tr id="row_header">
                        <td style="width: 20px;">TT</td>
                        <td style="width: 150px">Tòa án thụ lý</td>
                        <td>Vụ việc</td>
                        <td style="width: 80px;">Ngày ĐK</td>
                        <td style="width: 70px;">Tình trạng</td>
                        <td style="width: 80px;">Thao tác</td>
                    </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td><%#Eval("STT") %>
                    <asp:HiddenField ID="hddID" Value='<%#Eval("GroupDK") %>' runat="server" />
                </td>
                <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                    <%#Eval("TENTOAAN") %></a></td>
                <td style='line-height: 20px'>
                    <a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                        <b style="margin-right: 5px;">Mã vụ việc:</b><%#Eval("MaVuViec") %><br />
                        <b style="margin-right: 5px;">Tư cách tố tụng:</b><%#Eval("TenTuCachToTung") %><br />
                        <b style="margin-right: 5px;">Vụ việc:</b><%#Eval("TenVuViec") %></a></td>
                <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                    <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></a>
                </td>
                <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                    <%#Eval("TrangThaiDuyet") %></a></td>
                <td>
                    <div style="text-align: center;">
                        <div class="tooltip">
                            <a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                <img src='/UI/img/view.png' alt='Xem' style="width: 17px;" /></a>
                            <span class="tooltiptext  tooltip-bottom">Xem chi tiết đăng ký</span>
                        </div>
                        <div class="tooltip">
                            <asp:ImageButton ID="cmdLock" runat="server" ToolTip="Khóa" CssClass="grid_button"
                                OnClientClick="return confirm('Bạn thực sự muốn ngừng giao dịch điện tử cho mục đã đăng ký này? ');"
                                CommandName="Khoa" CommandArgument='<%#Eval("ID") %>'
                                ImageUrl="~/UI/img/stop.png" Width="20px" />
                            <span class="tooltiptext  tooltip-bottom">Ngừng giao dịch điện tử</span>
                        </div>
                        <div class="tooltip">
                            <asp:ImageButton ID="cmdUnlock" runat="server" ToolTip="Kích hoạt" CssClass="grid_button"
                                CommandName="KichHoat" CommandArgument='<%#Eval("ID") %>'
                                ImageUrl="~/UI/img/unlock.png" Width="20px" />
                            <span class="tooltiptext  tooltip-bottom">Kích hoạt nhận giao dịch điện tử</span>
                        </div>
                    </div>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
            </div>
        </FooterTemplate>
    </asp:Repeater>

</div>
