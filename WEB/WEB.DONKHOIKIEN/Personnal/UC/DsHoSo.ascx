<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DsHoSo.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.DsHoSo" %>
<asp:Panel ID="pn" runat="server">
    <style>
         .trangthaihs{font-weight:bold; width:100%; margin-bottom:5px; text-align:center;}
        .title_yeucau{font-weight:bold; display:none; }
        .str_yeucau{color:red;font-style:italic;text-align:center;}
    </style>
    <div class="right_full_width distance_bottom">
        <div class="guidonkien_head_nobg">
            <a href="/Personnal/Dsdon.aspx" class="color_black">Danh sách các đơn đã giao dịch trực tuyến</a>
            <asp:Literal ID="lttViewMore" runat="server"></asp:Literal>
        </div>
        <asp:HiddenField ID="hddSoLuong" runat="server" Value="5" />
        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
            <HeaderTemplate>
                <div class="CSSTableGenerator">
                    <table>
                        <tr id="row_header_red">
                            <td style="width: 20px;">TT </td>
                            <td>Nội dung</td>
                            <%-- <td style="width: 80px;">Loại vụ việc</td>--%>
                            <td style="width:25%;">Trạng thái đơn</td>
                            <td style="width: 50px;">Ngày gửi</td>                          
                            <td style="width: 50px;">VB tống đạt</td>
                            <td style="width: 55px;">Thao tác</td>
                        </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#Eval("STT") %>
                        <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID") %>' />
                        <asp:HiddenField ID="hddDonKKID" runat="server" Value='<%#Eval("ID") %>' />
                        <asp:HiddenField ID="hddTrangthai" runat="server" Value='<%#Eval("Trangthai") %>' />

                    </td>
                    <td>  <%# String.IsNullOrEmpty(Eval("MaVuViec")+"")? "": ("- <b>Mã hồ sơ: </b>"+Eval("MaVuViec") +"<br />")%>
                             - <b>Người gửi đơn: </b><%#Eval("TenNguoiGui") %><br />
                             -  <b>Vụ việc: </b>
                        <asp:Literal ID="lttTenVuViec" runat="server"></asp:Literal>
                        <br /><b>- Nơi nhận đơn: </b><%#Eval("TenToaAn") %>
                    </td>
                       <td>
                                <asp:Literal ID="lttTrangThai" runat="server"></asp:Literal></td>

                    <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayTao")) %></td>
                  
                    <td style="text-align: center;">
                        <asp:Literal ID="lttCountVB" runat="server"></asp:Literal></td>
                    <td>
                        <div class="align_center">
                            <div class="tooltip">
                                <asp:Literal ID="lttEdit" runat="server"></asp:Literal>
                                <asp:Literal ID="lttTooltip" runat="server"></asp:Literal>
                            </div> <div class="tooltip">
                                          <asp:ImageButton ID="imgBSTaiLieu" runat="server"
                                            ImageUrl="/UI/img/new.png" Width="21px"
                                            CommandArgument='<%#Eval("ID") %>' CommandName="ThemTL" />
                                         <asp:Literal ID="lttToolTipBSTaiLieu" runat="server"></asp:Literal>
                                        

                                    </div>
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate></table> </div></FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Panel>
