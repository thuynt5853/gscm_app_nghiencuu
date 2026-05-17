<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="VBTongDat.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.VBTongDat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="thongtin_lienhe">
        <div class="dangky_head border_radius_top">
            <div class="dangky_head_title">Văn bản, thông báo của Tòa án</div>
            <div class="dangky_head_right"></div>
        </div>
        <div class="dangky_content">

            <div class="border_search">
                <table style="width: 100%;">
                    <tr>
                    <td style="width: 110px;">Vụ việc, mã vụ việc, mã đăng ký</td>
                    <td style="width: 220px;">
                        <asp:TextBox ID="txtVuViec" CssClass="textbox" runat="server"
                            Width="200px" placeholder="Nhập tên vụ việc, mã vụ việc, mã đăng ký"></asp:TextBox></td>
                    <td style="width: 65px;">Tòa án</td>
                    <td>
                        <asp:HiddenField ID="hddToaAnID" runat="server" />
                        <asp:TextBox ID="txtToaAn" runat="server"
                            placeholder="(Gõ tên Tòa án vào đây để tìm kiếm)"
                            CssClass="textbox" Width="96%" AutoCompleteType="Search"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Tư cách tố tụng</td>
                    <td>
                        <asp:DropDownList ID="ddlTuCachToTung"
                            CssClass="dropbox" runat="server" Width="190px" Height="32px">
                            <asp:ListItem Value="" Text="----Chọn----"></asp:ListItem>
                           <%-- <asp:ListItem Value="0" Text="Chưa duyệt"></asp:ListItem>--%>
                            <asp:ListItem Value="NGUYENDON" Text="Nguyên đơn/Người khởi kiện"></asp:ListItem>
                            <asp:ListItem Value="BIDON" Text="Bị đơn/Người bị kiện"></asp:ListItem>
                            <asp:ListItem Value="QUYENNVLQ" Text="Người có quyền và NVLQ"></asp:ListItem>
                        </asp:DropDownList>
                        <%--<asp:TextBox ID="txtTuCachTT" CssClass="textbox" runat="server"
                            Width="200px" placeholder="Nhập tư cách tố tụng"></asp:TextBox></td>--%>
                    </td>
                    <td>Họ tên</td>
                    <td>
                        <asp:TextBox ID="txtHoten" CssClass="textbox" runat="server"
                            Width="200px" placeholder="Nhập họ tên"></asp:TextBox>

                    </td>
                </tr>
                <tr>
                    <td>Trạng thái</td>
                    <td>
                        <asp:DropDownList ID="dropTrangThai"
                            CssClass="dropbox" runat="server" Width="190px" Height="32px">
                            <%--<asp:ListItem Value="3" Text="----Chọn----"></asp:ListItem>
                           <asp:ListItem Value="0" Text="Chưa duyệt"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Đang giao dịch điện tử"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Ngừng giao dịch điện tử"></asp:ListItem>--%>
                        </asp:DropDownList>
                        
                    </td>
                    <td  ><asp:Button ID="cmdSearch" runat="server" CssClass="button_search right" Text="Tìm kiếm"
                            OnClick="cmdSearch_Click" /></td>
                </tr>
                </table>
            </div>
            <div class="msg_thongbao">
                <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
            </div>
            <!-------------------------------------------->
            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

            <asp:Panel ID="pnDS" runat="server">
                <div class="phantrang">
                    <div class="sobanghi">
                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                    </div>
                    <div class="sotrang">
                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                            OnClick="lbTBack_Click"><</asp:LinkButton>
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
                            OnClick="lbTNext_Click">></asp:LinkButton>
                        <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                            AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                </div>

                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                    <HeaderTemplate>

                        <div class="CSSTableGenerator">
                            <table>
                                <tr id="row_header">
                                    <td style="width: 20px;">TT</td>
                                    <td style="width: 150px;">Văn bản</td>
                                    <td style="width: 65px;">Ngày gửi</td>
                                    <td>Thông tin vụ việc</td>
                                    <td style="width: 130px;">Trạng thái</td>
                                    <td style="width: 60px;">Xem tệp đính kèm</td>
                                </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%#Eval("STT") %></td>
                            <td>
                                <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                                    CommandArgument='<%#Eval("VanBanID") %>' CommandName="view"></asp:LinkButton>
                            </td>
                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayGui")) %></td>
                            <td><%#Eval("TenVuViec") %> </td>
                            <td><%#Eval("TrangThaiDoc") %></td>
                            <td>
                                <div class="align_center">
                                    <asp:ImageButton ID="imgFile" runat="server" ImageUrl="../UI/img/view.png"
                                        CommandArgument='<%# Eval("VanBanID") %>' CommandName="dowload" />

                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table></div>
                    </FooterTemplate>
                </asp:Repeater>

                <div class="phantrang">
                    <div class="sobanghi">
                        <asp:HiddenField ID="hdicha" runat="server" />
                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                    </div>
                    <div class="sotrang">
                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                            OnClick="lbTBack_Click"><</asp:LinkButton>
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
                            OnClick="lbTNext_Click">></asp:LinkButton>
                        <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                            AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13) {
                    $("#<%= cmdSearch.ClientID %>").click();
                }
            });

        });
        function GetBase64File(base64, title) {

            // data should be your response data in base64 format

            const blob = dataURItoBlob(base64);
            const url = URL.createObjectURL(blob);

            // to open the PDF in a new window
            window.open(url, '_blank').document.title = title;
            //var pdfResult = base64;

            //let pdfWindow = window.open(title)
            //pdfWindow.document.write("<iframe width='100%' height='100%' src='data:application/pdf;base64, " + encodeURI(pdfResult) + "'></iframe>")
        }
        function dataURItoBlob(dataURI) {
            const byteString = window.atob(dataURI);
            const arrayBuffer = new ArrayBuffer(byteString.length);
            const int8Array = new Uint8Array(arrayBuffer);
            for (let i = 0; i < byteString.length; i++) {
                int8Array[i] = byteString.charCodeAt(i);
            }
            const blob = new Blob([int8Array], { type: 'application/pdf' });
            return blob;
        }

    </script>
</asp:Content>
