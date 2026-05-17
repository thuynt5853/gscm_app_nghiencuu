<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/AN_PHI.Master" CodeBehind="User_Infor.aspx.cs" Inherits="WEB.TP.User_Infor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/UI/css/style.css" rel="stylesheet" />
    <link href="/UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="/UI/css/chosen.css" rel="stylesheet" />


    <link href="/UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="/UI/js/jquery-3.3.1.js"></script>
    <script src="/UI/js/jquery-ui.min.js"></script>


    <style type="text/css">
        body {
            margin: 0 auto;
            padding: 0;
            font-family: arial;
            font-size: 13px;
            background-color: #ffffff;
        }

        #login_frame {
            margin: 0px;
            width: 100%;
            height: 1561px;
            background: none;
            background-color: #b6b0b0;
            background-size: 100% 100%;
            float: left;
            border-top: 1px solid #a91d1f;
        }

        #logo {
            width: 100%;
            height: 130px;
            margin-left: auto;
            margin-right: auto;
            background: url(UI/img/lgheader.png) no-repeat center;
        }

        .signin_frame {
            width: 685px;
            height: 612px;
            margin-top: 2px;
            background: none;
            background-color: #ffffff;
            margin-left: auto;
            margin-right: auto;
        }

        .titleds {
            float: left;
            width: 100%;
            text-align: center;
            margin-top: 0px;
            height: 36px;
            margin-bottom: 3px;
            line-height: 36px;
            color: #ffffff;
            font-size: 16px;
            font-weight: bold;
            background-color: #be1e1e;
        }

        .ctitem {
            float: left;
            width: 20%;
            height: 250px;
            padding-top: 35px;
        }

            .ctitem:hover {
                background: url(UI/img/bg_item.png);
            }

        .ctitemActive {
            float: left;
            width: 20%;
            height: 250px;
            background: url(UI/img/bg_item.png);
        }

        .khungnhap {
            width: 60%;
            margin-top: 13px;
            margin-left: 20%;
        }

            .khungnhap .box {
                display: block;
                float: left;
                margin-left: 12px;
                width: 581px;
                margin-bottom: 0px;
                border: none;
            }

            .khungnhap .textfield {
                display: block;
                height: 30px;
                width: 474px;
                margin: 8px 0;
                text-indent: 15px;
                border: solid 1px #8c0a0c;
                border-radius: 4px 4px 4px 4px;
            }

        .button {
            margin-top: 8px;
            background: none;
        }

        .menu {
            margin-bottom: 0px;
        }

        .buttoninput {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            background: #d02629;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            border: medium none;
        }

        .buttondisable {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
        }
    </style>
    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <ContentTemplate>

            <div id="login_frame">
                <div class="signin_frame" style="height: 306px;">
                    <div class="titleds">THÔNG TIN NGƯỜI DÙNG</div>
                    <div class="khungnhap" style="margin-left: 10px;">

                        <div class="box">
                            <div style="float: left; margin-top: 10px; width: 100px;">Tên đăng nhập</div>
                            <div style="float: left; margin-left: 5px;">
                                <asp:TextBox ID="txtUserName" runat="server" ReadOnly="true" Enabled="false" paceholder="Mã truy cập" CssClass="textfield"></asp:TextBox>
                            </div>
                        </div>

                        <div class="box">
                            <div style="float: left; margin-top: 10px; width: 100px;">Họ tên/ Đơn vị</div>
                            <div style="float: left; margin-left: 5px;">
                                <asp:TextBox ID="txt_HOTEN" runat="server" CssClass="textfield"></asp:TextBox>
                            </div>
                        </div>
                        <div class="box">
                            <div style="float: left; margin-top: 10px; width: 100px;">Điện thoại</div>
                            <div style="float: left; margin-left: 5px;">
                                <asp:TextBox ID="txt_DIENTHOAI" runat="server" CssClass="textfield"></asp:TextBox>
                            </div>
                        </div>
                        <div class="box">
                            <div style="float: left; margin-top: 10px; width: 100px;">Địa chỉ Email</div>
                            <div style="float: left; margin-left: 5px;">
                                <asp:TextBox ID="txt_EMAIL" runat="server" CssClass="textfield"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 100%; float: left; margin-left: 13px; color: #da0421; font-weight: bold; margin-top: 4px;">
                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                        </div>

                        <div style="margin-left: 113px; margin-top: 10px; float: left;">
                            <asp:Button ID="cmdLogIn" CssClass="button_checkchkso" Text="Lưu thông tin" runat="server" OnClick="cmdSave_Click" />
                        </div>

                    </div>
                </div>
                <div class="signin_frame" style="height: 598px; margin-top: 0px;">
                    <div class="titleds">THÔNG TIN ĐƠN VỊ THI HÀNH ÁN</div>
                    <div class="khungnhap" style="margin-left: 20px;">
                        <div style="width: 700px; float: left; margin-top: 10px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Tên tk của cơ quan thu<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_TEN_TK_THUHUONG" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 10px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Tên đơn vị<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_TEN" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Địa chỉ<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_DIACHI" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Điện thoại<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_DIENTHOAI_DV" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Email<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_EMAIL_DV" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Mã định danh<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_MA_DINH_DANH" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Số TK của cơ quan thu tại Kho bạc hoặc NH<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_SOTK_KHOBAC" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Tên kho bạc<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_TENTK_KHOBAC" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Mã CITAD<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_MA_KHOBAC" CssClass="textbox" runat="server"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Mã LH thu<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_MALOAIHINHTHU" CssClass="textbox" runat="server" Enabled="false" BackColor="#cccccc"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 8px;">
                            <div style="float: left; width: 100px; padding-top: 6px;">Tên LH thu<span class="must_input">(*)</span></div>
                            <div style="float: left;" runat="server">
                                <asp:TextBox ID="txt_TENLOAIHINHTHU" CssClass="textbox" runat="server" Enabled="false" BackColor="#cccccc"
                                    MaxLength="250" Width="474px"></asp:TextBox>
                            </div>
                        </div>
                        <div style="width: 700px; float: left; margin-top: 10px;">
                            <div style="height: 20px; float: left; font-size: 16px; margin: 10px; text-align: left; width: 95%; color: red; padding-left: 90px;">
                                <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div style="width: 600px; float: left; margin-top: 10px; margin-left: 10px;">
                            <div style="float: left; text-align: left; margin-left: 90px;">
                                <asp:Button ID="cmdSave" runat="server" CssClass="button_checkchkso" Text="Lưu" OnClick="cmdSave_dv_Click" />
                            </div>
                            <div style="float: left; text-align: left; margin-left: 5px;">
                                <asp:Button ID="cmdLichSu" runat="server" CssClass="button_checkchkso" Text="Lịch sử thay đổi" OnClick="cmdLichSu_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                function LoadModalDiv() {
                    var bcgDiv = document.getElementById("divBackground");
                    bcgDiv.style.display = "block";
                    if (bcgDiv != null) {

                        if (document.body.clientHeight > document.body.scrollHeight) {

                            bcgDiv.style.height = document.body.clientHeight + "px";
                        }
                        else {

                            bcgDiv.style.height = document.body.scrollHeight + "px";
                        }
                        bcgDiv.style.width = "100%";
                    }
                }
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel">
        <ProgressTemplate>
            <div class="processmodal">
                <div class="processcenter">
                    <img src="UI/img/process.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

