import Link from "next/link";
import Logo from "@/assets/logo-codelab-tailwind.svg";
import { cn } from "@/lib/utils";

type AuthLayoutProps = {
    children: React.ReactNode;
}


export default function AuthLayout({ children }: AuthLayoutProps)  {
    return (
        <main className={cn(
            "flex flex-col items-center justify-center gap-10 w-full h-screen"
        )}>
            <Link href="/" className="w-full block max-w-[200px]">
            <Logo/>
            </Link>

            {children}
        </main>
    )
}