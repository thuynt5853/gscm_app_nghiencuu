<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DonGhep.ascx.cs" Inherits="WEB.GSTP.QLAN.DONGHEP.DONKHAC.DonGhep" %>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<style type="text/css">
    .displayNone {
        display: none;
    }
</style>
<script>
    function popup_edit_DONGHEP(LoaiAnId, DONGHEPID = '', LOAIDON = '') {

        var link = "";
        if (LoaiAnId == '1') {
            //hình sự
            link = "/QLAN/DONGHEP/DONKHAC/AHS_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '2') {
            //dân sự
            link = "/QLAN/DONGHEP/DONKHAC/ADS_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '3') {
            //hôn nhân gia đình
            link = "/QLAN/DONGHEP/DONKHAC/AHN_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '4') {
            //kinh doanh thương mại
            link = "/QLAN/DONGHEP/DONKHAC/AKT_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '5') {
            //lạo động
            link = "/QLAN/DONGHEP/DONKHAC/ALD_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '6') {
            //hành chính
            link = "/QLAN/DONGHEP/DONKHAC/AHC_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        else if (LoaiAnId == '7') {
            //phá sản
            link = "/QLAN/DONGHEP/DONKHAC/APS_Thongtindon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON;
        }
        var width = 900;
        var height = 900;
        PopupCenter(link, "Thêm mới đơn", width, height);
    }
    function popup_XuLyDon(LoaiAnId, DONGHEPID = '', LOAIDON = '') {

        var link = "/QLAN/DONGHEP/PopupXuLyDon.aspx?DONGHEPID=" + DONGHEPID + "&LOAIDON=" + LOAIDON + "&LOAIAN=" + LoaiAnId;
        var width = 800;
        var height = 800;
        PopupCenter(link, "Xử lý đơn", width, height);
    }

    function ReLoadGrid() {
        $("#<%= cmdTimkiem.ClientID %>").click();
    }
</script>


<div class="boxchung">
    <h4 class="tleboxchung">Danh sách đơn</h4>
    <div class="boder" style="padding: 20px 10px;">
        <span class="msg_error">
            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
        <asp:Button ID="cmdTimkiem" runat="server" CssClass="displayNone" OnClick="lbtimkiem_Click" />
        <asp:LinkButton ID="lbtThemdonmoi" runat="server" CssClass="buttonpopup them_user" OnClick="lbThemMoiDon_Click">Thêm đơn mới</asp:LinkButton>
        <table class="table1">

            <tr>
                <td>
                    <asp:Label runat="server" ID="Label1" ForeColor="Red"></asp:Label>
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
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound" OnItemCommand="dgList_ItemCommand">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="LOAIVUVIEC" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="DONKKID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>TT</HeaderTemplate>
                                <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Loại đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("LOAIDON")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Người nộp đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENNGUOINOP")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tư cách tố tụng</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TCTT")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>CMND/ CCCD/ Hộ chiếu</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("SOCMND")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="45px" ItemStyle-HorizontalAlign="Right">
                                <HeaderTemplate>Năm sinh</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("NAMSINH")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày ghi trên đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("NGAYGHITRENDON") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Nội dung đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("NOIDUNGKHOIKIEN") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tình trạng giải quyết</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TTGQ")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>--%>
                            <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtXuLyDon" runat="server" CausesValidation="false" Text= <%# Eval("XLD") %>
                                        CommandName="XuLyDon" CommandArgument='<%#Eval("ID") + ";" +Eval("IDLOAIDON")%>'>  </asp:LinkButton>
                                    &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtSua" runat="server" CausesValidation="false" Text="Sửa"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") + ";" +Eval("IDLOAIDON")%>'>  </asp:LinkButton>
                                    &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"
                                                    CommandName="Xoa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');" CommandArgument='<%#Eval("ID") + ";" +Eval("IDLOAIDON")%>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang">
                        <div class="sobanghi">
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
