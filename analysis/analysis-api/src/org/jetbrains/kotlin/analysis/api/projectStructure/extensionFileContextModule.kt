/*
 * Copyright 2010-2024 JetBrains s.r.o. and Kotlin Programming Language contributors.
 * Use of this source code is governed by the Apache 2.0 license that can be found in the license/LICENSE.txt file.
 */

package org.jetbrains.kotlin.analysis.api.projectStructure

import com.intellij.openapi.util.Key
import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.analysis.api.KaImplementationDetail
import org.jetbrains.kotlin.psi.UserDataProperty


@Deprecated("Use 'analysisContextModule' instead.", ReplaceWith("analysisContextModule"), level = DeprecationLevel.ERROR)
@KaImplementationDetail
public var VirtualFile.analysisExtensionFileContextModule: KaModule?
    get() = analysisContextModule
    set(value) {
        analysisContextModule = value
    }
