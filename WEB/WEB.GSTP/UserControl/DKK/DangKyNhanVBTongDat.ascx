<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DangKyNhanVBTongDat.ascx.cs" Inherits="WEB.GSTP.UserControl.DKK.DangKyNhanVBTongDat" %>
<style>
    .home_ul {
        float: left;
        width: 98%;
        list-style: none;
    }

        .home_ul li {
            float: left;
            width: 35%;
            margin: 0px 2% 0 0;
            line-height: 20px;text-transform:uppercase;
        }

            .home_ul li:nth-child(2) {
                margin-right: 0;
                width: 60%;
            }

        .home_ul a {
            color: #333;
            text-decoration: underline;
            float: left;
            width: 100%;
        }

    .home_ul_child {
        float: left;
width: 95%;
margin-left: 3%;
    }

        .home_ul_child li {
            float: left;
            width: 98%;
            margin: 0px 0px 5px 20px;
            line-height: 20px;text-transform:none;
        }
        .home_ul_child li:nth-child(2), .home_ul_child li:nth-child(4), .home_ul_child li:nth-child(6) { width: 98%;}


</style>
<asp:Panel ID="pn" runat="server">
    <div class="boxchung">
        <h4 class="tleboxchung bg_title_group" style="text-transform: uppercase;">Thống kê Đơn khởi kiện</h4>
        <div class="boder" style="padding: 10px 1.5%; float: left; width: 97%;">
            <ul class="home_ul">
                <asp:LinkButton ID="lkDKNhanVB" runat="server"
                    OnClick="lkDKNhanVB_Click"></asp:LinkButton>
                <asp:LinkButton ID="lkAdmin_NguoiDung" runat="server"
                    OnClick="lkAdmin_NguoiDung_Click"></asp:LinkButton>
            </ul>
        </div>
    </div>
</asp:Panel>
