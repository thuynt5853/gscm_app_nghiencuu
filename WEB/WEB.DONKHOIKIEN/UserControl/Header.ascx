<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Header" %>


<div>
    <style>
        .ngungGiaoDich {
            background: url("/UI/img/stop.png") no-repeat 3px 6px;
        }

        .dkGiaoDich {
            background: url("/UI/img/unlock.png") no-repeat 3px 6px;
        }

        .cssPnGiaoDich {
            float: left;
            border-bottom: solid 1px #dcdcdc;
            list-style-type: none;
            width: 100%;
            padding: 4px 0px;
            color: #333;
            text-transform: none;
        }
    </style>

    <asp:HiddenField ID="hddIsShowTraCuu" runat="server" Value="0" />
    <div class="header">
        <div class="content_center">
            <div class="banner">
                <div class="banner_right">
                    <div class="menu_right">
                        <asp:Panel ID="pnUserInfo" runat="server">
                            <div class="userinfo">
                                <div class="dropdown">
                                    <a href="/Personnal/PersonalIndex.aspx" class="dropbtn userinfo_ico">
                                        <asp:Literal ID="lttUserName" runat="server"></asp:Literal></a>

                                    <div class="menu_child">
                                        <div class="arrow_up_border"></div>
                                        <div class="arrow_up"></div>
                                        <ul>
                                            <li class="ttuser"><a href="/Personnal/TaikhoanInfo.aspx">Thông tin tài khoản</a></li>
                                            <li class="changepass"><a href="/Personnal/DoiMK.aspx">Đổi mật khẩu</a></li>
                                            <li class="listvbtongdat"><a href="/Personnal/VBTongDat.aspx">Văn bản, thông báo của Tòa án</a></li>
                                            <li class="listdk"><a href="/Personnal/DsDangKyNhanVBTongDat.aspx">Danh sách vụ việc</a></li>
                                            <asp:Panel ID="pnNgungGiaoDich" CssClass="cssPnGiaoDich" runat="server">
                                                <li class="ngungGiaoDich">
                                                    <asp:LinkButton ID="lkNgungGiaoDich" runat="server" OnClick="lkNgungGiaoDich_Click" Text="Ngừng giao dịch"></asp:LinkButton>
                                                </li>
                                            </asp:Panel>
                                            <asp:Panel ID="pnDKGiaoDich" CssClass="" runat="server">
                                                <li class="dkGiaoDich">
                                                    <asp:LinkButton ID="lkDKGiaoDich" runat="server" OnClick="lkDKGiaoDich_Click" Visible="false" Text="ĐK lại giao dịch điện tử"></asp:LinkButton>
                                                </li>
                                            </asp:Panel>
                                            <li class="singout">
                                                <asp:LinkButton ID="lkSigout" runat="server" OnClick="lkSigout_Click" Text="Đăng xuất"></asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnLogin" runat="server" Visible="false">
                            <%--  <div class="dropdown">
                                 <div class="menu_child">
                                    <div class="arrow_up_border"></div>
                                    <div class="arrow_up"></div>
                                    <ul style="width: 250px; padding: 15px; padding-bottom: 0px;">
                                        <li style="border-bottom: none;">
                                            <asp:TextBox ID="txtUserName" runat="server" placeholder="Tên truy cập" CssClass="textbox_login" Width="95%" /></li>
                                        <li style="border-bottom: none;">
                                            <asp:TextBox ID="txtPass" runat="server" placeholder="Mật khẩu" CssClass="textbox_login" Width="95%" TextMode="Password" /></li>
                                        <li style="border-bottom: none;">
                                            <div class="dangnhap">
                                                <asp:Button ID="cmdLogin" runat="server"
                                                    CssClass="dangnhap_btn" Text="Đăng nhập"
                                                    OnClientClick="return CheckLogin();" OnClick="cmdLogin_Click" />
                                            </div>
                                      
                                        </li>
                                    </ul>
                                </div>
                            </div>--%>
                            <a href="/login.aspx" class="link_login login_line" class="dropbtn userinfo_ico">Đăng nhập</a>

                            <a href="/DangKy.aspx" class="link_login" style="margin-right: 0px;">Đăng ký</a>
                        </asp:Panel>

                    </div>
                    <!------------end banner right---------->
                </div>

            </div>
        </div>
    </div>
    <div class="menu_ngang">
        <div class="content_center">
            <div class="menu_left">
                <ul><asp:Literal ID="lttMenu" runat="server"></asp:Literal></ul>
                    <%-- 
                    <li><a href="javascript:;" class="menu_link">cổng TTTĐT TATC</a></li>
                    <li><a class="menu_link menu_active" href="/trangchu.aspx">trang chủ</a></li>
                    <li><a href="javascript:;" class="menu_link">đăng ký cấp sao bản án tài liệu</a></li>
                    <li><a href="/TraCuu.aspx" class="menu_link">Tra cứu</a></li>
                    <li><a href="/LienHe.aspx" class="menu_link">liên hệ</a></li>
                    --%>
            
            </div>
        </div>
    </div>
</div>

