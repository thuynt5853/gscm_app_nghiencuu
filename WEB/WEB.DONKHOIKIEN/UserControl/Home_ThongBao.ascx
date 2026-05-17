<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Home_ThongBao.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Home_ThongBao" %>
<asp:HiddenField ID="hddSoLuong" runat="server" Value="3" />
<style>
    .thongbao_home:last-child{margin-right:0;}
</style>


<div class="content_center">
    <!------------------------------------------>
    <asp:HiddenField ID="hddGroupNewsHH" runat="server" Value="huongdannopdon" />
    <div class="thongbao_home">
        <div class="thongbao_home_header">
            <div class="thongbao_home_header_title">
                <asp:Literal ID="lstHuongDan" runat="server"></asp:Literal>
            </div>
            <div class="thongbao_home_header_arrow_down"></div>
        </div>
        <div class="thongbao_content">
            <asp:Repeater ID="rpt2" runat="server">
                <HeaderTemplate>
                    <ul>
                </HeaderTemplate>
                <ItemTemplate>
                    <li><a href='ChiTietTin.aspx?tID=<%#Eval("ID") %>&&cID=<%#Eval("ChuyenMucID") %>'><%#Eval("TieuDe") %></a></li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
    <!------------------------------------------>
    <asp:HiddenField ID="hddGroupNewsTT" runat="server" Value="tinhoatdong" />
    <div class="thongbao_home">
        <div class="thongbao_home_header">
            <div class="thongbao_home_header_title">
                <asp:Literal ID="lstThongBao" runat="server"></asp:Literal>
            </div>
            <div class="thongbao_home_header_arrow_down"></div>
        </div>
        <div class="thongbao_content">
            <asp:Repeater ID="rpt" runat="server">
                <HeaderTemplate>
                    <ul>
                </HeaderTemplate>
                <ItemTemplate>
                    <li><a href='ChiTietTin.aspx?tID=<%#Eval("ID") %>&&cID=<%#Eval("ChuyenMucID") %>'><%#Eval("TieuDe") %></a></li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
    <!------------------------------------------>
    <div class="thongbao_home" style="margin-right:0;">
        <div class="thongbao_home_header">
            <div class="thongbao_home_header_title"><a href='/Lienhe.aspx'>Liên hệ</a></div>
            <div class="thongbao_home_header_arrow_down"></div>
        </div>
        <div class="thongbao_content" style="padding-top: 13px;">
            <asp:DropDownList ID="dropToaAn" runat="server" 
                CssClass="chosen-select" Width="100%"
                AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged">
            </asp:DropDownList>
            <div style="margin-top:5px;">
            <asp:Literal ID="lstThongtinHT" runat="server"></asp:Literal></div>
        </div>
    </div>
        <!--------------------------------------------->
        <script>
            function pageLoad(sender, args)
            {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
</div>
