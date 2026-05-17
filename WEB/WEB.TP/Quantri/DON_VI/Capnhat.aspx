<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs" Inherits="WEB.TP.Quantri.DON_VI.Capnhat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <title>Cập nhật thông tin đơn vị</title>
    <style>
        .content_body {
            width: 96%;
            margin: 20px 2%;
        }

        .cell_label {
            margin-left: 5px;
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
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="Ajax_Manager_Updata" runat="server">
            <ContentTemplate>
                <div class="content_form">
                    <div class="content_body" style="width: 750px; margin-top: 0px;">
                        <div class="content_form_body" style="width: 750px;">
                            <div class="content_form_head" style="width: 750px;">
                                <div class="content_form_head_title">
                                    <asp:Label ID="lbl_title_anphi" runat="server" Text="Cập nhật thông tin đơn vị"></asp:Label>
                                </div>
                                <div class="content_form_head_right"></div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Tên tk của cơ quan thu<span class="must_input">(*)</span></div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_TEN_TK_THUHUONG" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>

                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Tên đơn vị<span class="must_input">(*)</span></div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_TEN" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Địa chỉ<span class="must_input">(*)</span></div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_DIACHI" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Điện thoại</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_DIENTHOAI" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Email</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_EMAIL" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Mã định danh</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_MA_DINH_DANH" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Số TK của cơ quan thu tại Kho bạc hoặc NH</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_SOTK_KHOBAC" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Tên kho bạc</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_TENTK_KHOBAC" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Mã CITAD</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_MA_KHOBAC" CssClass="textbox" runat="server"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Mã LH thu</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_MALOAIHINHTHU" CssClass="textbox" runat="server" Enabled="false" BackColor="#cccccc"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 8px;">
                                <div style="float: left; width: 100px; padding-top: 6px;">Tên LH thu</div>
                                <div style="float: left;" runat="server">
                                    <asp:TextBox ID="txt_TENLOAIHINHTHU" CssClass="textbox" runat="server" Enabled="false" BackColor="#cccccc"
                                        MaxLength="250" Width="570px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 10px;">
                                <div style="height: 20px; float: left; font-size: 16px; margin: 10px; text-align: left; width: 95%; color: red; padding-left: 90px;">
                                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div style="width: 600px; float: left; margin-top: 0px; margin-left: 100px;">
                                <div style="text-align: center;">
                                    <asp:Button ID="cmdSave" runat="server" CssClass="button" Text="Lưu" OnClick="cmdSave_Click" />
                                    <a href="javascript:;" onclick="window.close();" class="button">Đóng</a>
                                </div>
                                 <div style="float: left; text-align: left; margin-left: 5px;">
                                <asp:Button ID="cmdLichSu" runat="server" CssClass="button_checkchkso" Text="Lịch sử thay đổi" OnClick="cmdLichSu_Click" />
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
<script>
    function ReloadParent() {
        window.onunload = function (e) {
            opener.Loadds_tha();
        };
        // window.close();
    }
</script>
