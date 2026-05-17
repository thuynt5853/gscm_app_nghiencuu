<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="WEB.TP.UC.Header" %>
<div class="header">
    <div class="headertop">
        <a href="http://www.toaan.gov.vn" target="_blank">
            <div class="logo_toaan"></div>
        </a>
        <a href="http://thads.moj.gov.vn" target="_blank">
            <div class="logo_botuphap"></div>
        </a>
        <div class="logo_text" style="text-align: center;">
            QUẢN LÝ THU, NỘP TIỀN TẠM ỨNG ÁN PHÍ
            <div style="text-align:left;margin-top:6px;font-size:15px;margin-left:3px;">
                <asp:Literal ID="li_tendonvi" runat="server"></asp:Literal>
            </div>
        </div>
        <div class="taikhoan" style="z-index:2;">
            <div class="userinfo">
                <div class="dropdown">
                    <a href="javascript:;" class="dropbtn userinfo_ico">
                        <asp:Literal ID="lstUserName" runat="server"></asp:Literal></a>

                    <div class="menu_child">
                        <div class="arrow_up_border"></div>
                        <div class="arrow_up"></div>
                        <ul>
                            <li class="singout">
                                <asp:LinkButton ID="lkSigout" runat="server"
                                    OnClick="lkSigout_Click" Text="Đăng xuất"></asp:LinkButton>
                            </li>
                            <li class="changepass infors"><a href="/User_Infor.aspx">Thông tin người dùng</a></li>
                            <li class="changepass"><a href="/ChangePass.aspx">Đổi mật khẩu</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div runat="server" id="tkth_div" class="taikhoan" style="top: 79px; z-index: 1;">
            <div class="userinfo">
                <div class="dropdown">
                     <a href="/User_Infor.aspx" class="dropbtn userinfo_ico tk_th">
                    Bạn chưa cập nhật "Tên tk thụ hưởng <span style="color:red;">(*)</span>"
                         </a>
                </div>
            </div>
        </div>
    </div>
    <div class="menu">
        <div class="content_form">
            <div class="msg_thongbao">
                <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
            </div>
            <div style="display: none;">
                <asp:Repeater ID="rptMenu" runat="server" OnItemCommand="rptMenu_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <ItemTemplate>
                        <asp:LinkButton ID="lbtChuongTrinh"
                            runat="server" CssClass="menubutton" Text='<%#Eval("TENMENU") %>'
                            CommandName="SELECT" CommandArgument='<%#Eval("ID").ToString() +";"+ Eval("DUONGDAN").ToString()%>' />
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <asp:Literal ID="ltt" runat="server"></asp:Literal>
        </div>
    </div>
</div>