<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="ChiTietVB.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.ChiTietVB" %>

<%@ Register Src="~/Personnal/UC/DsFileDonKK.ascx" TagPrefix="uc1" TagName="DsFileDonKK" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .content_item_row {
            float: left;
            font-weight: bold;
            width: 100%;
        }

        #tblDetail tr td {
            background: white;
            padding: 10px 7px;
        }

        .title_form {
            float: left;
            width: 100%;
            text-transform: uppercase;
            font-weight: bold;
            margin-top: 10px;
            margin-bottom: 5px;
        }
    </style>

    <style>
        .table1 tr, td {
            padding-left: 0px;
        }
    </style>
    <div class="right_full_width distance_bottom">
        <div class="thongtin_lienhe">
            <div class="right_full_width_head">
                <a href="javascript:;" class="dowload_head">Chi tiết</a>
                <div class="dangky_head_right">
                    <div class="tooltip">
                        <a href="/Personnal/VBTongDat.aspx">
                            <img src="../UI/img/top_back.png" style="width: 28px; float: right;" />
                        </a>
                        <span class="tooltiptext  tooltip-bottom">Quay lại</span>
                    </div>

                </div>
            </div>
            <div class="content_right">
                <table style="background: #f5f5f5; width: 100%;margin-bottom:15px;" cellpadding="1" id="tblDetail">
                    <tr>
                        <td style="width: 115px;" class="background_gray">Vụ việc</td>
                        <td>
                            <asp:Literal ID="lttVuViec" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 115px;" class="background_gray">Thông tin thụ lý</td>
                        <td>
                            <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                        </td>
                    </tr>
                </table>
                <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>


                <asp:Panel ID="pnVBTongDat" runat="server">
                    <div class="title_form">Văn bản, thông báo của Tòa án</div>

                    <asp:Repeater ID="rptFile" runat="server"
                        OnItemCommand="rptFile_ItemCommand">
                        <HeaderTemplate>
                            <div class="CSSTableGenerator">
                                <table>
                                    <tr id="row_header">
                                        <td style="width: 20px;">TT</td>
                                        <td>Tên văn bản</td>
                                        <td style="width: 70px;">Ngày gửi</td>
                                        <td style="width: 100px;">Ngày tiếp nhận</td>
                                        <td style="width: 75px;">Tệp đính kèm</td>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Container.ItemIndex + 1 %></td>
                                <td>
                                    <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                                        CommandArgument='<%#Eval("ID") %>' CommandName="dowload"></asp:LinkButton>
                                </td>
                                <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayGui")) %></td>
                                <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayDoc")) %></td>
                                <td>
                                    <div class="align_center">
                                        <asp:ImageButton ID="imgFile" runat="server" 
                                            Width="27px"
                                            ImageUrl="../UI/img/download_file26.png"
                                            CommandArgument='<%#Eval("ID") %>' CommandName="dowload" />
                                    </div>
                                </td>

                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table></div>
                        </FooterTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <div style="float:left; text-align:center;width:100%;margin-top:20px;margin-bottom:20px">
                <a href="VBTongDat.aspx" class="buttoninput quaylai">Quay lại</a></div>
            </div>
        </div>
    </div>



</asp:Content>
